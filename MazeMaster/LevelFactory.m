//
//  LevelFactory.m
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "LevelFactory.h"
#import "Level.h"

@implementation LevelFactory

static LevelFactory *s_sharedLevelFactory = nil;
+(id) levelFactory
{
   if ( s_sharedLevelFactory == nil )
   {
      s_sharedLevelFactory = [[self alloc] init];
   }
   return s_sharedLevelFactory;
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

+ (Level *)levelForLevelNumber:(int)levelNumber
{
   Level* level = [[Level alloc] init];
   [level setLevelNumber:levelNumber];

   return level;
}

@end
