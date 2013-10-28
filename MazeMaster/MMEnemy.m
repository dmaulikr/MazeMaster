//
//  MMEnemy.m
//  MazeMaster
//
//  Created by Fila, Justin on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "MMEnemy.h"
#import "GameController.h"
#import "Level.h"
#import "Maze.h"
#import "Tile.h"

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
   // the shared texture cache returns an autoreleased object
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
         _shouldCalculateNewPath = NO;
         break;
      case e_WANDERING:
         self.texture = _wanderingTexture;
         self.maxVelocity = ccp(.5,.5);
         break;
      case e_CHASING:
         self.texture = _chasingTexture;
         self.maxVelocity = ccp(.8,.8);
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
      switch (_state)
      {
         case e_CHASING:
            if ([self calculatePathToTile:_target])
               [self beginExecutingCurrentPath];
            break;

         case e_WANDERING:
         {
            while (![self calculatePathToTile:_target])
               _target = [[GameController sharedController].level.maze getRandomTile];

            NSLog(@"%@ wandering to %@", self.travelerKey, NSStringFromCGPoint(_target.position));
            [self beginExecutingCurrentPath];
         }
         default:
            break;
      }
      _shouldCalculateNewPath = NO;
   }
}

@end
