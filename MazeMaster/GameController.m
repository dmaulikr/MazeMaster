//
//  Game.m
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "GameController.h"
#import "Player.h"

#import "Level.h"
#import "GameLayer.h"
#import "PlayerTypedefs.h"

// for singleton
GameController *s_gameController = nil;

@interface GameController()
{
   NSMutableArray *_swipeStack;
}
@end

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

-(BOOL) character:(MMCharacter *)character
  canMoveFromTile:(Tile *)tile
{
   if (character.direction == e_NONE)
      return NO;
   
   return [tile getAdjacentEdgeForDirection:character.direction].walkable;
}
@end
