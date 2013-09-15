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

@synthesize level = _level;
@synthesize playerDirection = _playerDirection;
@synthesize gameLayer = _gameLayer;
@synthesize isPlayerMoving = _isPlayerMoving;

-(id) init
{
   if ( self = [super init] )
   {
      _level = [[Level alloc] init];
   }
   return self;
}

+(GameController *) gameController
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
   [super dealloc];
}

@end
