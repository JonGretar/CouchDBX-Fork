//
//  Lucene.m
//  CouchDBX
//
//  Created by Jón Grétar Borgþórsson on 9.10.2009.
//  Copyright 2009 Think Software. All rights reserved.
//

#import "Lucene.h"


@implementation Lucene


static Lucene *luceneServer = nil;

+ (Lucene *)server
{
  @synchronized(self)
  {
  if (luceneServer == nil)
    {
    luceneServer = [[self alloc] init];
    }
  }
  return luceneServer;
}

+ (id)allocWithZone:(NSZone *)zone 
{ 
	@synchronized(self) 
	{ 
		if (luceneServer == nil) 
      { 
        luceneServer = [super allocWithZone:zone]; 
        return luceneServer; 
      } 
	} 
  
	return nil; 
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
