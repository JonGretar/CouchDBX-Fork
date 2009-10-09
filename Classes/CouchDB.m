//
//  CouchDB.m
//  CouchDBX
//
//  Created by Jón Grétar Borgþórsson on 9.10.2009.
//  Copyright 2009 Think Software. All rights reserved.
//

#import "CouchDB.h"


@implementation CouchDB

static CouchDB *couchDBServer = nil;

#pragma mark CouchDB

-(void)start
{
	
	environment = [[NSMutableDictionary alloc] init];
	[environment setObject:NSHomeDirectory() 
                  forKey:@"HOME"];
	[environment setObject:@"/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin" 
                  forKey:@"PATH"];
	[environment setObject:[@"~/Library/Preferences/org.couchdb.CouchDBX.ini" stringByExpandingTildeInPath] 
                  forKey:@"LOCAL_CONFIG_FILE"];
  [environment setObject:[@"~/Library/Application Support/CouchDBX/config.d" stringByExpandingTildeInPath] 
                  forKey:@"LOCAL_CONFIG_DIR"];
	
	[task setEnvironment:environment];
	
	NSMutableString *launchPath = [[NSMutableString alloc] init];
	[launchPath appendString:[[NSBundle mainBundle] resourcePath]];
	[launchPath appendString:@"/couchdbx-core"];
	[task setCurrentDirectoryPath:launchPath];
	
	[launchPath appendString:@"/couchdb/bin/couchdb"];
	[task setLaunchPath:launchPath];
	[task setStandardInput:in];
	[task setStandardOutput:out];
	
	NSFileHandle *fh = [out fileHandleForReading];
	NSNotificationCenter *nc;
	nc = [NSNotificationCenter defaultCenter];
	
	[nc addObserver:self
         selector:@selector(taskTerminated:)
             name:NSTaskDidTerminateNotification
           object:task];
  
  [nc addObserver:self
         selector:@selector(dataReady:)
             name:NSFileHandleReadCompletionNotification
           object:fh];
	
  [task launch];
	
  [fh readInBackgroundAndNotify];
}

-(void)stop
{
	NSLog(@"CouchDB Stopping");
	
  // We now just kill
  // NSFileHandle *writer;
  // writer = [in fileHandleForWriting];
  // [writer writeData:[@"q().\n" dataUsingEncoding:NSASCIIStringEncoding]];
  // [writer closeFile];
  [task terminate];
}

-(void)taskTerminated:(NSNotification *)note
{
  [self cleanup];
}

-(void)cleanup
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dataReady:(NSNotification *)n
{
  NSData *d;
  d = [[n userInfo] valueForKey:NSFileHandleNotificationDataItem];
  if ([d length]) {
		[delegate appendData:d];
  }
  if (task)
  [[out fileHandleForReading] readInBackgroundAndNotify];
}

#pragma mark Delegate stuff

-(void)setDelegate:(id)newDelegate;
{
  delegate = newDelegate;
}

-(id)delegate
{
  return delegate;
}

#pragma mark Singleton

+ (CouchDB *)server
{
  @synchronized(self)
  {
    if (couchDBServer == nil)
    {
      couchDBServer = [[self alloc] init];
    }
  }
  return couchDBServer;
}

+ (id)allocWithZone:(NSZone *)zone 
{ 
	@synchronized(self) 
	{ 
		if (couchDBServer == nil) 
      { 
        couchDBServer = [super allocWithZone:zone]; 
        return couchDBServer; 
      } 
	} 
  
	return nil; 
} 

-(id) init
{
  self = [super init];
  NSLog(@"CouchDB Starting");
	
	in = [[NSPipe alloc] init];
	out = [[NSPipe alloc] init];
	task = [[NSTask alloc] init];
  
  return self;
}

- (id)copyWithZone:(NSZone *)zone 
{ 
	return self; 
} 

- (id)retain 
{ 
	return self; 
} 

- (NSUInteger)retainCount 
{ 
	return NSUIntegerMax; 
} 

- (void)release 
{ 
} 

- (id)autorelease 
{ 
	return self; 
}

@end
