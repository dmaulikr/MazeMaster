//
//  Game.m
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "GameController.h"
#import "Player.h"

// for singleton
GameController *s_gameController = nil;

@implementation GameController

-(id) init
{
   if ( self = [super init] )
   {
      _level = [Level new];
      _swipeStack = [NSMutableArray new];
//      _playerDirection = e_NONE;
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

-(BOOL) canMoveFromTile:(Tile *)tile inDirection:(CharacterDirection)direction
{
   if (direction == e_NONE)
      return NO;

   return [tile getAdjacentEdgeForDirection:_gameLayer.playerSprite.direction].walkable;
}

@end
