/*
 *  Author: Jan Lehnardt <jan@apache.org>
 *  This is Apache 2.0 licensed free software
 */
#import "CouchDBXApplicationController.h"

@implementation CouchDBXApplicationController

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSNotification *)notification
{
	return YES;
}

- (void)windowWillClose:(NSNotification *)aNotification 
{
    [self stop];
}

-(void)awakeFromNib
{
	
	menuIcon = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CouchDBXMenuIcon" ofType:@"png"]];	
	
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:29] retain]; //NSVariableStatusItemLength] retain];
	[statusItem setHighlightMode:YES];
	[statusItem setTitle:@""];
	[statusItem setMenu:toolMenu];
    [statusItem setImage:menuIcon];
    [statusItem setAlternateImage:menuIcon];
	
	[statusItem setEnabled:YES];
}

-(IBAction)start:(id)sender
{
    if([task isRunning]) {
		[self stop];
		return;
    } 
    
    [self launchCouchDB];
}

-(void)stop
{
    NSFileHandle *writer;
    writer = [in fileHandleForWriting];
    [writer writeData:[@"q().\n" dataUsingEncoding:NSASCIIStringEncoding]];
    [writer closeFile];
	
    [start setImage:[NSImage imageNamed:@"start.png"]];
    [start setLabel:@"start"];
}

-(void)launchCouchDB
{
    [start setImage:[NSImage imageNamed:@"stop.png"]];
    [start setLabel:@"stop"];
	
	
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
		   selector:@selector(dataReady:)
			   name:NSFileHandleReadCompletionNotification
			 object:fh];
	
	[nc addObserver:self
		   selector:@selector(taskTerminated:)
			   name:NSTaskDidTerminateNotification
			 object:task];
	
  	[task launch];
	

  	[fh readInBackgroundAndNotify];
}

-(void)taskTerminated:(NSNotification *)note
{
    [self cleanup];
}

-(void)cleanup
{
    [task release];
    task = nil;
    
    [in release];
    in = nil;
	[out release];
	out = nil;
	
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)dataReady:(NSNotification *)n
{
    NSData *d;
    d = [[n userInfo] valueForKey:NSFileHandleNotificationDataItem];

    if (task)
		[[out fileHandleForReading] readInBackgroundAndNotify];
}

@end