//
//  Game.m
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "GameController.h"

// for singleton
GameController *s_gameController = nil;

@implementation GameController

-(id) init
{
   if ( self = [super init] )
   {
      _level = [Level new];
      _swipeStack = [NSMutableArray new];
      _playerDirection = e_NONE;
   }
   return self;
}

+(GameController *) sharedController
{
   if ( s_gameController == nil )
   {
      s_gameController = [[GameController alloc] init];
   }
   
   return s_gameController;
}

-(void) dealloc
{
   [_level dealloc];
   [_swipeStack release];
   [super dealloc];
}

- (BOOL)playerCanMoveFromTile:(Tile *)tile
{
   if (_playerDirection == e_NONE)
      return NO;

   return [tile getAdjacentEdgeForDirection:_playerDirection].walkable;
}

- (WalkableDirections)getWalkableDirectionsFromTile:(Tile *)tile
{
   return (([tile getAdjacentEdgeForDirection:e_NORTH].walkable)? kNorthWalkable : 0) |
          (([tile getAdjacentEdgeForDirection:e_EAST].walkable)? kEastWalkable : 0) |
          (([tile getAdjacentEdgeForDirection:e_SOUTH].walkable)? kSouthWalkable : 0) |
          (([tile getAdjacentEdgeForDirection:e_WEST].walkable)? kWestWalkable : 0);
}

- (void)pushSwipeStack:(PlayerDirection)direction
{
   [_swipeStack addObject:[NSNumber numberWithInt:direction]];
}

- (PlayerDirection)popSwipeStack
{
   PlayerDirection direction = e_NONE;
   if (_swipeStack.count)
   {
      NSNumber *directionNumber = [_swipeStack lastObject];
      direction = directionNumber.intValue;
      [_swipeStack removeLastObject];
   }
   return direction;
}

- (PlayerDirection)topSwipeStack
{
   PlayerDirection direction = e_NONE;
   if (_swipeStack.count)
   {
      NSNumber *directionNumber = [_swipeStack lastObject];
      direction = directionNumber.intValue;
   }
   return direction;
}

- (void)clearSwipeStack
{
   [_swipeStack removeAllObjects];
}

- (BOOL)swipeStackIsEmpty
{
   return !_swipeStack.count;
}

@end
