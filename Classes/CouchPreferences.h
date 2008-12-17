//
//  Preferences.h
//  CouchDBX
//
//  Created by Jón Grétar Borgþórsson on 23.11.2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CouchPreferences : NSObject {
	IBOutlet NSUserDefaultsController *defaultsController;
	IBOutlet NSPanel *preferenceWindow;
	IBOutlet NSButton *isNetworked;
	IBOutlet NSTextField *port;
}

- (void)writeINIFile;
- (IBAction) saveAndClose: (id)sender;
- (IBAction) abortAndClose: (id)sender;

@end
