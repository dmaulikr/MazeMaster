//
//  Player.m
//  MazeMaster
//
//  Created by Justin Fila on 8/19/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "Player.h"


@implementation Player

- (id)init
{
   if (self == [super init])
   {
      // initialize stuff
   }
   return self;
}

+(Player *) playerWithFile:(NSString *)filename
{
   return [CCSprite spriteWithFile:filename];
}

- (void)dealloc
{
   [super dealloc];
}

@end
