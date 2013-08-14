//
//  LevelFactory.m
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "LevelFactory.h"

@implementation LevelFactory

static LevelFactory *sharedLevelFactory = nil;
+(id) levelFactory
{
   if ( sharedLevelFactory == nil )
   {
      sharedLevelFactory = [[self alloc] init];
   }
   return sharedLevelFactory;
}

-(id) init
{
   if (self = [super init]) {
      // initialize variables
      NSLog(@"Initialize Variables");
   }
   return self;
}

-(void) dealloc
{
   NSLog(@"dealloc");
   
   [super dealloc];
}

@end
