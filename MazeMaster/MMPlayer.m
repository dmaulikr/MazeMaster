//
//  MMPlayer.m
//  MazeMaster
//
//  Created by Justin Fila on 8/19/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "MMPlayer.h"

@implementation MMPlayer

-(id)initWithFile:(NSString *)filename
{
   if (self = [super initWithFile:filename])
   {
      self.isPlayer = YES;
   }
   return self;
}

-(void) attack
{
   NSLog(@"Player attack");
}

+(MMPlayer *) playerWithFile:(NSString *)filename
{
   // TODO: this is weird
   MMPlayer *player = (MMPlayer *)[super characterWithFile:filename];
   player.isPlayer = YES;
   return player;
}

- (void)stopMoving
{
   [super stopMoving];
}

- (void)dealloc
{
   [super dealloc];
}

@end
