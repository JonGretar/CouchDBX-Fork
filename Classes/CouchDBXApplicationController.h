//
//  CouchDBX
//
//  Author: Jan Lehnardt <jan@apache.org>
//  Updated by Jón Grétar Borgþórsson on 9.10.2009.
//  This is Apache 2.0 licensed free software
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <BWToolkitFramework/BWToolkitFramework.h>
#import "CouchPreferences.h"
#import "CouchDB.h"

@interface CouchDBXApplicationController : NSObject{
	
	// Status Bar Menu
	NSStatusItem *statusItem;
	NSImage *menuIcon;
	
	// Main Window Window
	IBOutlet NSWindow *mainWindow;
	IBOutlet NSTextView *outputView;
  IBOutlet WebView *webView;
  IBOutlet BWSplitView *splitView;
	
	//Extra
	NSUserDefaultsController *defaults;
	
	CouchPreferences *preferences; 
}

-(IBAction)showMainWindow:(id)sender;
-(IBAction)browse:(id)sender;
-(IBAction)restart:(id)sender;
-(IBAction)quit:(id)sender;


@end
