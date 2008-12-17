/*
 Author: Jan Lehnardt <jan@apache.org>
 This is Apache 2.0 licensed free software
 */

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "CouchPreferences.h"

@interface CouchDBXApplicationController : NSObject{
	
	// Status Bar Menu
	NSStatusItem *statusItem;
	IBOutlet NSMenu *toolMenu;
	NSImage *menuIcon;
	
	// Log Window
	IBOutlet NSPanel *logPanel;
	IBOutlet NSTextView *outputView;
	
    // CouchDB
    NSTask *task;
    NSPipe *in, *out;
	
	//Extra
	NSUserDefaultsController *defaults;
	NSMutableDictionary *environment;
	CouchPreferences *preferences; 
}

-(IBAction)showLogPanel:(id)sender;
-(IBAction)browse:(id)sender;
-(IBAction)restart:(id)sender;
-(IBAction)quit:(id)sender;

-(void)stop;
-(void)launchCouchDB;

-(void)taskTerminated:(NSNotification *)note;
-(void)cleanup;

@end
