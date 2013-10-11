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
         if (CGPointEqualToPoint(tilePos, ccp(1,5))   ||
             CGPointEqualToPoint(tilePos, ccp(1,6))   ||
             CGPointEqualToPoint(tilePos, ccp(1,7))   ||
             CGPointEqualToPoint(tilePos, ccp(1,9))   ||
             CGPointEqualToPoint(tilePos, ccp(1,10))  ||
             CGPointEqualToPoint(tilePos, ccp(2,1))   ||
             CGPointEqualToPoint(tilePos, ccp(2,2))   ||
             CGPointEqualToPoint(tilePos, ccp(2,7))   ||
             CGPointEqualToPoint(tilePos, ccp(2,9))   ||
             CGPointEqualToPoint(tilePos, ccp(2,10))  ||
             CGPointEqualToPoint(tilePos, ccp(2,11))  ||
             CGPointEqualToPoint(tilePos, ccp(3,10))  ||
             CGPointEqualToPoint(tilePos, ccp(3,11))  ||
             CGPointEqualToPoint(tilePos, ccp(4,3))   ||
             CGPointEqualToPoint(tilePos, ccp(4,4))   ||
             CGPointEqualToPoint(tilePos, ccp(4,8))   ||
             CGPointEqualToPoint(tilePos, ccp(4,9))   ||
             CGPointEqualToPoint(tilePos, ccp(5,2))   ||
             CGPointEqualToPoint(tilePos, ccp(5,9))   ||
             CGPointEqualToPoint(tilePos, ccp(5,10))  ||
             CGPointEqualToPoint(tilePos, ccp(5,11))  ||
             CGPointEqualToPoint(tilePos, ccp(5,12))  ||
             CGPointEqualToPoint(tilePos, ccp(6,1))   ||
             CGPointEqualToPoint(tilePos, ccp(6,2))   ||
             CGPointEqualToPoint(tilePos, ccp(6,3))   ||
             CGPointEqualToPoint(tilePos, ccp(6,8))   ||
             CGPointEqualToPoint(tilePos, ccp(6,9))   ||
             CGPointEqualToPoint(tilePos, ccp(7,2))   ||
             CGPointEqualToPoint(tilePos, ccp(7,7))   ||
             CGPointEqualToPoint(tilePos, ccp(7,8))   ||
             CGPointEqualToPoint(tilePos, ccp(7,9))   ||
             CGPointEqualToPoint(tilePos, ccp(7,10))  ||
             CGPointEqualToPoint(tilePos, ccp(8,3))   ||
             CGPointEqualToPoint(tilePos, ccp(8,4))   ||
             CGPointEqualToPoint(tilePos, ccp(8,5))   ||
             CGPointEqualToPoint(tilePos, ccp(8,11))  ||
             CGPointEqualToPoint(tilePos, ccp(8,12))  ||
             CGPointEqualToPoint(tilePos, ccp(9,4))   ||
             CGPointEqualToPoint(tilePos, ccp(9,5))   ||
             CGPointEqualToPoint(tilePos, ccp(9,6))   ||
             CGPointEqualToPoint(tilePos, ccp(9,7))   ||
             CGPointEqualToPoint(tilePos, ccp(9,10))  ||
             CGPointEqualToPoint(tilePos, ccp(10,1))  ||
             CGPointEqualToPoint(tilePos, ccp(10,6))  ||
             CGPointEqualToPoint(tilePos, ccp(10,7))  ||
             CGPointEqualToPoint(tilePos, ccp(10,8))  ||
             CGPointEqualToPoint(tilePos, ccp(10,12)) ||
             CGPointEqualToPoint(tilePos, ccp(11,1))  ||
             CGPointEqualToPoint(tilePos, ccp(11,2))  ||
             CGPointEqualToPoint(tilePos, ccp(11,3))  ||
             CGPointEqualToPoint(tilePos, ccp(12,5))  ||
             CGPointEqualToPoint(tilePos, ccp(12,8))  ||
             CGPointEqualToPoint(tilePos, ccp(12,9))  ||
             CGPointEqualToPoint(tilePos, ccp(12,10)))
            tile.eastEdge.walkable = NO;

         if (CGPointEqualToPoint(tilePos, ccp(1,4))   ||
             CGPointEqualToPoint(tilePos, ccp(2,4))   ||
             CGPointEqualToPoint(tilePos, ccp(2,7))   ||
             CGPointEqualToPoint(tilePos, ccp(2,8))   ||
             CGPointEqualToPoint(tilePos, ccp(3,4))   ||
             CGPointEqualToPoint(tilePos, ccp(3,6))   ||
             CGPointEqualToPoint(tilePos, ccp(3,11))  ||
             CGPointEqualToPoint(tilePos, ccp(4,4))   ||
             CGPointEqualToPoint(tilePos, ccp(4,6))   ||
             CGPointEqualToPoint(tilePos, ccp(5,2))   ||
             CGPointEqualToPoint(tilePos, ccp(5,7))   ||
             CGPointEqualToPoint(tilePos, ccp(6,5))   ||
             CGPointEqualToPoint(tilePos, ccp(6,7))   ||
             CGPointEqualToPoint(tilePos, ccp(6,12))  ||
             CGPointEqualToPoint(tilePos, ccp(7,5))   ||
             CGPointEqualToPoint(tilePos, ccp(7,6))   ||
             CGPointEqualToPoint(tilePos, ccp(7,12))  ||
             CGPointEqualToPoint(tilePos, ccp(8,1))   ||
             CGPointEqualToPoint(tilePos, ccp(8,5))   ||
             CGPointEqualToPoint(tilePos, ccp(8,12))  ||
             CGPointEqualToPoint(tilePos, ccp(9,1))   ||
             CGPointEqualToPoint(tilePos, ccp(9,11))  ||
             CGPointEqualToPoint(tilePos, ccp(10,1))  ||
             CGPointEqualToPoint(tilePos, ccp(10,5))  ||
             CGPointEqualToPoint(tilePos, ccp(10,10)) ||
             CGPointEqualToPoint(tilePos, ccp(10,11)) ||
             CGPointEqualToPoint(tilePos, ccp(11,3))  ||
             CGPointEqualToPoint(tilePos, ccp(11,5))  ||
             CGPointEqualToPoint(tilePos, ccp(11,8))  ||
             CGPointEqualToPoint(tilePos, ccp(11,10)) ||
             CGPointEqualToPoint(tilePos, ccp(11,12)) ||
             CGPointEqualToPoint(tilePos, ccp(12,5))  ||
             CGPointEqualToPoint(tilePos, ccp(12,7))  ||
             CGPointEqualToPoint(tilePos, ccp(12,10)) ||
             CGPointEqualToPoint(tilePos, ccp(11,12)))
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
