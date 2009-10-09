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
  
  
	[[CouchDB server] start];
  [[CouchDB server] setDelegate:self];
  
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
    [[CouchDB server] stop];
    [preferences writeINIFile];
	// Couch is restarted too soon so lets time the restart to 2 seconds
	[self performSelector:@selector(start) withObject:[CouchDB server] afterDelay:2.0];
	//[self launchCouchDB];
}

-(IBAction)quit:(id)sender
{
    [[CouchDB server] stop];
	
	[NSApp terminate:NULL];
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



@end