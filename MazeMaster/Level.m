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
//      [_maze testMaze];
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
         [self setupEdgesForLevel1];
         break;

      case 2:
         [self setupEdgesForLevel2];
         break;

      case 3:
         [self setupEdgesForLevel3];
         break;

      default:
         break;
   }
}

- (void)setupEdgesForLevel1
{
   for (NSMutableArray *tiles in _maze.tiles)
      for (Tile *tile in tiles)
      {
         CGPoint tilePos = tile.position;
         if (CGPointEqualToPoint(tilePos, ccp(2,1)) ||
             CGPointEqualToPoint(tilePos, ccp(2,2)) ||
             CGPointEqualToPoint(tilePos, ccp(4,3)) ||
             CGPointEqualToPoint(tilePos, ccp(4,4)) ||
             CGPointEqualToPoint(tilePos, ccp(1,5)) ||
             CGPointEqualToPoint(tilePos, ccp(1,6)) ||
             CGPointEqualToPoint(tilePos, ccp(1,7)) ||
             CGPointEqualToPoint(tilePos, ccp(2,7)))
            tile.eastEdge.walkable = NO;

         if (CGPointEqualToPoint(tilePos, ccp(1,4)) ||
             CGPointEqualToPoint(tilePos, ccp(2,4)) ||
             CGPointEqualToPoint(tilePos, ccp(3,4)) ||
             CGPointEqualToPoint(tilePos, ccp(4,4)) ||
             CGPointEqualToPoint(tilePos, ccp(2,7)) ||
             CGPointEqualToPoint(tilePos, ccp(3,6)) ||
             CGPointEqualToPoint(tilePos, ccp(4,6)))
            tile.northEdge.walkable = NO;
      }
}

- (void)setupEdgesForLevel2
{
}

- (void)setupEdgesForLevel3
{
}

@end
