//
//  Preferences.m
//  CouchDBX
//
//  Created by Jón Grétar Borgþórsson on 23.11.2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

// [Couch]
// ConsoleStartupMsg=Apache CouchDB is starting.
// DbRootDir=.//var/lib/couchdb
// Port=5984
// BindAddress=127.0.0.1
// DocumentRoot=.//share/couchdb/www
// LogFile=.//var/log/couchdb/couch.log
// UtilDriverDir=.//lib/couchdb/erlang/lib/couch-0.8.0-incubating/priv/lib
// LogLevel=info
// [Couch Query Servers]
// javascript=.//bin/couchjs .//share/couchdb/server/main.js



#import "CouchPreferences.h"


@implementation CouchPreferences



- (void)writeINIFile
{

	NSString *path = [@"~/Library/Preferences/com.jongretar.couchdbx.ini" stringByExpandingTildeInPath];
	NSMutableString *contents = [[NSMutableString alloc] init];
	NSError *error;
	
	[contents appendString:@"[Couch]"];
	[contents appendString:@"\nConsoleStartupMsg=Apache CouchDB is starting."];
	
	[contents appendString:@"\nDbRootDir="];
	[contents appendString:[@"~/Documents/CouchDB" stringByExpandingTildeInPath]];
	
	[contents appendString:@"\nPort=5984"];
	[contents appendString:@"\nBindAddress=127.0.0.1"];
	[contents appendString:@"\nDocumentRoot=.//share/couchdb/www"];
	[contents appendString:@"\nLogFile=.//var/log/couchdb/couch.log"];
	[contents appendString:@"\nUtilDriverDir=.//lib/couchdb/erlang/lib/couch-0.8.0-incubating/priv/lib"];
	[contents appendString:@"\nLogLevel=info"];
	
	[contents appendString:@"\n\n[Couch Query Servers]"];
	[contents appendString:@"\njavascript=.//bin/couchjs .//share/couchdb/server/main.js"];

	
	
	[contents writeToFile:path atomically:YES
			 encoding:NSASCIIStringEncoding error:&error];

}

@end
