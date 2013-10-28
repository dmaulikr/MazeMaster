//
//  Player.m
//  MazeMaster
//
//  Created by Justin Fila on 8/19/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "Player.h"

@implementation Player

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

+(Player *) playerWithFile:(NSString *)filename
{
   // TODO: this is weird
   Player *player = (Player *)[super characterWithFile:filename];
   player.isPlayer = YES;
   return player;
}

- (void)dealloc
{
   [super dealloc];
}

@end
