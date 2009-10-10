//
//  Preferences.h
//  CouchDBX
//
//  Created by Jón Grétar Borgþórsson on 23.11.2008.
//

#import <Cocoa/Cocoa.h>


@interface CouchPreferences : NSObject {
	IBOutlet NSUserDefaultsController *defaultsController;
}

- (void)writeINIFile;


@end
