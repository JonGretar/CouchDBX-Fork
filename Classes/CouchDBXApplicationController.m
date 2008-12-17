/*
 *  Author: Jan Lehnardt <jan@apache.org>
 *  This is Apache 2.0 licensed free software
 */
#import "CouchDBXApplicationController.h"


@implementation CouchDBXApplicationController

+ (void)initialize
{
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"IsNetworked"];
	[defaultValues setObject:@"5984" forKey:@"Port"];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
	NSLog(@"Registered Defaults: %@", defaultValues);
}

-(void)awakeFromNib
{
	
	preferences = [[CouchPreferences alloc] init];
	[preferences writeINIFile];
	
	menuIcon = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CouchDBXMenuIcon" ofType:@"png"]];	
	
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:29] retain];
	[statusItem setHighlightMode:YES];
	[statusItem setTitle:@""];
	[statusItem setMenu:toolMenu];
    [statusItem setImage:menuIcon];
    [statusItem setAlternateImage:menuIcon];
	
	[statusItem setEnabled:YES];
	
	[outputView setString:@"CouchDBX Started...\n\n"];
	
	[self launchCouchDB];
}

-(IBAction)showLogPanel:(id)sender
{
	[logPanel makeKeyAndOrderFront:self];
}

-(IBAction)browse:(id)sender
{
	NSString *urlString = [NSString stringWithFormat:@"http://127.0.0.1:%@/_utils/", 
						   [[NSUserDefaults standardUserDefaults] objectForKey:@"Port"]];
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlString]];
}

-(IBAction)restart:(id)sender
{
    if([task isRunning]) {
		[self stop];
		//return;
    }
    [preferences writeINIFile];
	// Couch is restarted too soon so lets time the restart to 2 seconds
	[self performSelector:@selector(launchCouchDB) withObject:nil afterDelay:2.0];
	//[self launchCouchDB];
}

-(IBAction)quit:(id)sender
{
    [self stop];
	
	[NSApp terminate:NULL];
}


-(void)stop
{
	NSLog(@"CouchDB Stopping");
	
    NSFileHandle *writer;
    writer = [in fileHandleForWriting];
    [writer writeData:[@"q().\n" dataUsingEncoding:NSASCIIStringEncoding]];
    [writer closeFile];
}


-(void)launchCouchDB
{
	NSLog(@"CouchDB Starting");
	
	in = [[NSPipe alloc] init];
	out = [[NSPipe alloc] init];
	task = [[NSTask alloc] init];
	
	environment = [[NSMutableDictionary alloc] init];
	[environment setObject:@"Hello World" 
					forKey:@"TESTENV"];
	[environment setObject:NSHomeDirectory() 
					forKey:@"HOME"];
	[environment setObject:@"/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin" 
					forKey:@"PATH"];
	[environment setObject:[@"~/Library/Preferences/com.jongretar.couchdbx.ini" stringByExpandingTildeInPath] 
					forKey:@"INI_FILE"];
	
	[task setEnvironment:environment];
	
	NSMutableString *launchPath = [[NSMutableString alloc] init];
	[launchPath appendString:[[NSBundle mainBundle] resourcePath]];
	[launchPath appendString:@"/CouchDb"];
	[task setCurrentDirectoryPath:launchPath];
	
	[launchPath appendString:@"/startCouchDb.sh"];
	[task setLaunchPath:launchPath];
	[task setStandardInput:in];
	[task setStandardOutput:out];
	
	NSFileHandle *fh = [out fileHandleForReading];
	NSNotificationCenter *nc;
	nc = [NSNotificationCenter defaultCenter];
	
	[nc addObserver:self
		   selector:@selector(taskTerminated:)
			   name:NSTaskDidTerminateNotification
			 object:task];
	
	[nc addObserver:self
		   selector:@selector(dataReady:)
			   name:NSFileHandleReadCompletionNotification
			 object:fh];
	
  	[task launch];
	
  	[fh readInBackgroundAndNotify];
}

-(void)taskTerminated:(NSNotification *)note
{
    [self cleanup];
}

-(void)cleanup
{
	NSLog(@"CouchDB Memory Cleanup");
	
    [task release];
    task = nil;
    
    [in release];
    in = nil;
	[out release];
	out = nil;
	
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)appendData:(NSData *)d
{
    NSString *s = [[NSString alloc] initWithData: d
                                        encoding: NSUTF8StringEncoding];
    NSTextStorage *ts = [outputView textStorage];
    [ts replaceCharactersInRange:NSMakeRange([ts length], 0) withString:s];
    [outputView scrollRangeToVisible:NSMakeRange([ts length], 0)];
    [s release];
}

- (void)dataReady:(NSNotification *)n
{
    NSData *d;
    d = [[n userInfo] valueForKey:NSFileHandleNotificationDataItem];
    if ([d length]) {
		[self appendData:d];
    }
    if (task)
		[[out fileHandleForReading] readInBackgroundAndNotify];
}


@end