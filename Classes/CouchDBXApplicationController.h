/*
 Author: Jan Lehnardt <jan@apache.org>
 This is Apache 2.0 licensed free software
 */

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface CouchDBXApplicationController : NSObject{
	NSStatusItem *statusItem;
	IBOutlet NSMenu *toolMenu;
	NSImage *menuIcon;
	
    IBOutlet NSToolbarItem *start;
	
	
    
    NSTask *task;
    NSPipe *in, *out;
}

-(IBAction)start:(id)sender;

-(void)launchCouchDB;
-(void)stop;
-(void)taskTerminated:(NSNotification *)note;
-(void)cleanup;

@end
