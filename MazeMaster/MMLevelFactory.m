//
//  MMLevelFactory.m
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "MMLevelFactory.h"
#import "MMLevel.h"

@implementation MMLevelFactory

static MMLevelFactory *s_sharedLevelFactory = nil;
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

+ (MMLevel *)levelForLevelNumber:(int)levelNumber
{
   MMLevel *level = nil;
   
   switch (levelNumber) {
      case 1:
         level = [[MMLevel alloc] initWithRows:13
                                  andColumns:14];
         [level setLevelNumber:levelNumber];
         break;
         
      case 2:
         level = [[MMLevel alloc] initWithRows:10
                                  andColumns:6];
         [level setLevelNumber:levelNumber];
         break;
         
      case 3:
         level = [[MMLevel alloc] initWithRows:15
                                  andColumns:15];
         [level setLevelNumber:levelNumber];
         break;
         
      default:
         break;
   }

   return level;
}

@end
