//
//  Game.m
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "Game.h"

@implementation Game

-(id) init
{
   if ( self = [super init] )
   {
      _level = [[Level alloc] init];
   }
   return self;
}

-(void) dealloc
{
   [super dealloc];
   
   [_level release];
}

@end