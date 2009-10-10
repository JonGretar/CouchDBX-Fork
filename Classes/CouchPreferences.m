//
//  Preferences.m
//  CouchDBX
//
//  Created by Jón Grétar Borgþórsson on 23.11.2008.
//




#import "CouchPreferences.h"


@implementation CouchPreferences



- (void)writeINIFile
{

	NSString *path = [@"~/Library/Preferences/org.couchdb.CouchDBX.ini" stringByExpandingTildeInPath];
	NSMutableString *contents = [[NSMutableString alloc] init];
	NSError *error;
	
	// CouchDB
	[contents appendString:@"[couchdb]"];
	[contents appendString:@"\nos_process_timeout=60000"];
  
	[contents appendString:@"\ndatabase_dir="];
	[contents appendString:[@"~/Documents/CouchDB" stringByExpandingTildeInPath]];
	
	[contents appendString:@"\nview_index_dir="];
	[contents appendString:[@"~/Documents/CouchDB" stringByExpandingTildeInPath]];
	
	// httpd
	[contents appendString:@"\n\n[httpd]"];
	
	[contents appendString:@"\nport="];
	[contents appendString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Port"] ];
	
	[contents appendString:@"\nbind_address="];
	[contents appendString:[[NSUserDefaults standardUserDefaults] objectForKey:@"BindAddress"] ];
	
	// log
	[contents appendString:@"\n\n[log]"];
	
	[contents appendString:@"\nfile="];
	[contents appendString:[@"~/Library/Logs/CouchDBX.log" stringByExpandingTildeInPath]];
	
	[contents appendString:@"\nlevel="];
	[contents appendString:[[NSUserDefaults standardUserDefaults] objectForKey:@"LogLevel"] ];
  
  // lucene
  [contents appendString:@"\n[external]"];
  [contents appendString:@"\nfti=/usr/bin/java -server -jar couchdb-lucene-0.4-jar-with-dependencies.jar -search"];
  [contents appendString:@"\n[update_notification]"];
  [contents appendString:@"\nindexer=/usr/bin/java -server -jar couchdb-lucene-0.4-jar-with-dependencies.jar -index"];
  [contents appendString:@"\n[httpd_db_handlers]"];
  [contents appendString:@"\n_fti = {couch_httpd_external, handle_external_req, <<\"fti\">>}"];
	
	
	
	// Write File
	[contents writeToFile:path atomically:YES
			 encoding:NSASCIIStringEncoding error:&error];

}


@end
