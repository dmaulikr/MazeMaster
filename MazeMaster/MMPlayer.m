//
//  MMPlayer.m
//  MazeMaster
//
//  Created by Justin Fila on 8/19/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "MMPlayer.h"
#import "MMGameController.h"
#import "MMVictim.h"
#import "MMLevel.h"

@implementation MMPlayer

-(id)initWithFile:(NSString *)filename
{
   if (self = [super initWithFile:filename])
   {
      self.isPlayer = YES;
      self.victim = nil;
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

- (BOOL)stopMoving
{
   return [super stopMoving];
}

- (void)dealloc
{
   [super dealloc];
}

- (void) collisionCheckWithVictim
{
   // collision detection for each victim
   // TODO: could just use current tile
   for (MMVictim *victim in [MMGameController sharedController].level.victims)
   {
      if ( !CGRectIsNull(CGRectIntersection(self.boundingBox, victim.boundingBox)) )
      {
         _victim = victim;
         _victim.state = e_FOLLOWING;
         _victim.isMoving = YES;
         _victim.shouldMove = YES;
         _victim.direction = e_DUMMY;
         [_victim pushMoveStack:self.direction];
      }
   }
}

- (void)updatePositionForTile:(MMTile *)nextTile atLocation:(CGPoint)nextTileLocation mazeMovement:(BOOL)mazeMoving
{
   [super updatePositionForTile:nextTile atLocation:nextTileLocation mazeMovement:mazeMoving];
   
   if (!_victim)
      [self collisionCheckWithVictim];
   else if (_victim.direction == e_DUMMY)
   {
      [_victim moveFromDelayToMoveStack];
      _victim.direction = [_victim popMoveStack];
   }
}

@end
