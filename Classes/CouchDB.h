//
//  CouchDB.h
//  CouchDBX
//
//  Created by Jón Grétar Borgþórsson on 9.10.2009.
//  Copyright 2009 Think Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CouchDB : NSObject {
  // CouchDB
  NSTask *task;
  NSPipe *in, *out;
  NSMutableDictionary *environment;
  id delegate;
}

+ (CouchDB *)server;

-(void)setDelegate:(id)newDelegate;
-(id)delegate;

-(void)stop;
-(void)start;

-(void)taskTerminated:(NSNotification *)note;
-(void)cleanup;

@end
