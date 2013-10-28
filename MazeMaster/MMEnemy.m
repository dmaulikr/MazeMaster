//
//  MMEnemy.m
//  MazeMaster
//
//  Created by Fila, Justin on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "MMEnemy.h"

@interface MMEnemy()
{
   CCTexture2D *_chasingTexture;
   CCTexture2D *_wanderingTexture;
   CCTexture2D *_sleepingTexture;
}

@end

@implementation MMEnemy

- (void)setupTextures
{
   _sleepingTexture = [[CCTextureCache sharedTextureCache] addImage:@"enemy_front_sleeping.png"];
   _wanderingTexture = [[CCTextureCache sharedTextureCache] addImage:@"enemy_front_wandering.png"];
   _chasingTexture = [[CCTextureCache sharedTextureCache] addImage:@"enemy_front_chasing.png"];
}

-(id)initWithFile:(NSString *)filename
{
   if (self = [super initWithFile:filename])
   {
      [self setupTextures];
      _state = e_SLEEPING;
      [self scheduleUpdate];
   }
   return self;
}

- (void)setState:(EnemyState)state
{
   switch (state)
   {
      case e_SLEEPING:
         self.texture = _sleepingTexture;
         break;
      case e_WANDERING:
         self.texture = _wanderingTexture;
         break;
      case e_CHASING:
         self.texture = _chasingTexture;
      default:
         break;
   }
   _state = state;
}

-(void) attack
{
   NSLog(@"Enemy attack");
}

+(MMEnemy *) enemyWithFile:(NSString *)filename
{
   // TODO: this is weird
   return (MMEnemy *)[super characterWithFile:filename];
}

- (void)update:(ccTime)delta
{
   if (_shouldCalculateNewPath)
   {
      if ([self calculatePathToCharacter:_target])
         [self beginExecutingCurrentPath];

      _shouldCalculateNewPath = NO;
   }
}

- (void)dealloc
{
   [super dealloc];
}

@end
