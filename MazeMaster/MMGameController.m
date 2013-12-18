//
//  MMGameController.m
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "MMGameController.h"
#import "MMPlayer.h"

#import "MMLevel.h"
#import "MMGameLayer.h"
#import "MMPlayerTypedefs.h"
#import "MMTile.h"

// for singleton
MMGameController *s_gameController = nil;

@interface MMGameController()
{
   NSMutableArray *_swipeStack;
}
@end

@implementation MMGameController

-(id) init
{
   if ( self = [super init] )
   {
      _level = [MMLevel new];
      _swipeStack = [NSMutableArray new];
   }
   return self;
}

+(MMGameController *) sharedController
{
   if ( s_gameController == nil )
      s_gameController = [[MMGameController alloc] init];
   
   return s_gameController;
}

-(void) dealloc
{
   [_level dealloc];
   [_swipeStack release];
   [super dealloc];
}

-(BOOL) character:(MMCharacter *)character
  canMoveFromTile:(MMTile *)tile
{
   if (character.direction == e_NONE)
      return NO;
   
   return [tile getAdjacentEdgeForDirection:character.direction].walkable;
}
@end
