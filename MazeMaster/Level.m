//
//  Level.m
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "Level.h"

@implementation Level

@synthesize levelNumber = _levelNumber;
@synthesize maze = _maze;

-(id) init
{
   if ( self = [super init] )
   {
      _maze = [[Maze alloc] initWithRows:5
                             withColumns:5];
      [_maze testMaze];
   }
   return self;
}

-(id) initWithRows:(int)rows andColumns:(int)cols
{
   if ( self = [super init] )
   {
      _maze = [[Maze alloc] initWithRows:rows
                             withColumns:cols];
      [_maze testMaze];
   }
   return self;
}

-(void) dealloc
{
   [_maze release];
   [super dealloc];
}

- (void)setLevelNumber:(int)levelNumber
{
   _levelNumber = levelNumber;
   switch (_levelNumber)
   {
      case 1:
         [self setupLevel1];
         break;

      case 2:
         [self setupLevel2];
         break;

      case 3:
         [self setupLevel3];
         break;

      default:
         break;
   }
}

- (void)setupLevel1
{
   NSLog(@"setting up level 1");
}

- (void)setupLevel2
{
   NSLog(@"setting up level 2");
}

- (void)setupLevel3
{
   NSLog(@"setting up level 3");
}

@end
