/*
 *  Author: Jan Lehnardt <jan@apache.org>
 *  This is Apache 2.0 licensed free software
 */
#import "CouchDBXApplicationController.h"

@implementation CouchDBXApplicationController

-(void)awakeFromNib
{
	
	menuIcon = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CouchDBXMenuIcon" ofType:@"png"]];	
	
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:29] retain];
	[statusItem setHighlightMode:YES];
	[statusItem setTitle:@""];
	[statusItem setMenu:toolMenu];
    [statusItem setImage:menuIcon];
    [statusItem setAlternateImage:menuIcon];
	
	[statusItem setEnabled:YES];
	
	[self launchCouchDB];
}

-(IBAction)browse:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://127.0.0.1:5984/_utils/"]];
}

-(IBAction)restart:(id)sender
{
    if([task isRunning]) {
		NSLog(@"Stopping CouchDB");
		[self stop];
		//return;
    }
    
	// Couch is restarted too soon so lets time the restart to 2 seconds
	[self performSelector:@selector(launchCouchDB) withObject:nil afterDelay:2.0];
	//[self launchCouchDB];
}

-(IBAction)quit:(id)sender
{
	NSLog(@"Termination application CouchDBX");
    [self stop];
	
	[NSApp terminate:NULL];
}


-(void)stop
{
    NSFileHandle *writer;
    writer = [in fileHandleForWriting];
    [writer writeData:[@"q().\n" dataUsingEncoding:NSASCIIStringEncoding]];
    [writer closeFile];
}


-(void)launchCouchDB
{
	NSLog(@"Startin CouchDB");
	
	in = [[NSPipe alloc] init];
	out = [[NSPipe alloc] init];
	task = [[NSTask alloc] init];
	
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
	
  	[task launch];
	

  	[fh readInBackgroundAndNotify];
}

-(void)taskTerminated:(NSNotification *)note
{
	NSLog(@"taskTerminated: notification");
    [self cleanup];
}

-(void)cleanup
{
	NSLog(@"Cleanup of CouchDB");
    [task release];
    task = nil;
    
    [in release];
    in = nil;
	[out release];
	out = nil;
	
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end