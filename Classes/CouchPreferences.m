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
	
	[contents appendString:@"\ndatabase_dir="];
	[contents appendString:[@"~/Documents/CouchDB" stringByExpandingTildeInPath]];
	
	[contents appendString:@"\nview_index_dir="];
	[contents appendString:[@"~/Documents/CouchDB" stringByExpandingTildeInPath]];
	
	// httpd
	[contents appendString:@"\n\n[httpd]"];
	
	[contents appendString:@"\nport="];
	[contents appendString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Port"] ];
	
	[contents appendString:@"\nbind_address="];
	if ( [[NSUserDefaults standardUserDefaults] objectForKey:@"IsNetworked"] == [NSNumber numberWithBool:YES] ) {
		[contents appendString:@"0.0.0.0"];
	}
	else 
	{
		[contents appendString:@"127.0.0.1"];
	}
	
	// log
	[contents appendString:@"\n\n[log]"];
	
	[contents appendString:@"\nfile="];
	[contents appendString:[@"~/Library/Logs/CouchDBX.log" stringByExpandingTildeInPath]];
	
	[contents appendString:@"\nlevel="];
	[contents appendString:@"info"];
	
	
	
	// Write File
	[contents writeToFile:path atomically:YES
			 encoding:NSASCIIStringEncoding error:&error];

}


- (IBAction) saveAndClose: (id)sender
{
	// FIXME: Add More Validations Later
	if ([port intValue]) {
		[defaultsController save:NULL];
		[preferenceWindow orderOut:NULL];
	}
	else
	{
		[port setStringValue:@"5984"];
	}
	
}

- (IBAction) abortAndClose: (id)sender
{
	[defaultsController revert:NULL];
	[preferenceWindow orderOut:NULL];
}

@end
