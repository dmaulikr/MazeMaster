//
//  PlayerLayer.m
//  MazeMaster
//
//  Created by Gregory Klein on 8/14/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "PlayerLayer.h"

@implementation PlayerLayer

- (id)init
{
   if (self == [super init])
   {
      [self setupDrawingForPlayer];
   }
   return self;
}

- (void)dealloc
{
   [super dealloc];
}

- (void)setupDrawingForPlayer
{
   ccDrawColor4F(0, 0, 1.0f, 0.8f);
   ccPointSize([[CCDirector sharedDirector] winSize].height/12.0);
}

- (void)draw
{
   [self setupDrawingForPlayer];
   ccDrawPoint(_position);
}

@end
