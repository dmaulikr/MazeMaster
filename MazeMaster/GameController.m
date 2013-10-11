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
   return [tile getAdjacentEdgeForDirection:_playerDirection].walkable;
}

- (void)pushSwipeStack:(PlayerDirection)direction
{
   [_swipeStack addObject:direction];
}

- (PlayerDirection)popSwipeStack
{
   PlayerDirection direction = -1;
   if (_swipeStack.count)
   {
      direction = [_swipeStack lastObject];
      [_swipeStack removeLastObject];
   }
   return direction;
}

- (void)clearSwipeStack
{
   [_swipeStack removeAllObjects];
}

@end
