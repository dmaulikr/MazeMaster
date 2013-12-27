//
//  MMEnemy.m
//  MazeMaster
//
//  Created by Fila, Justin on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "MMEnemy.h"
#import "MMGameController.h"
#import "MMLevel.h"
#import "MMMaze.h"
#import "MMTile.h"

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
      [self scheduleUpdate];
      [self setupTextures];
      _state = e_SLEEPING;
   }
   return self;
}

- (void)setAwarenessProximityWithSize:(CGSize)size
{
   _awarenessProximity.size = size;
   _awarenessProximity.origin = ccp(self.position.x + (self.boundingBox.size.width/2.0) -
                                       (_awarenessProximity.size.width/2.0),
                                    self.position.y + (self.boundingBox.size.height/2.0) -
                                       (_awarenessProximity.size.height/2.0));
}

- (void)setPosition:(CGPoint)position
{
   _awarenessProximity.origin = ccp(position.x + (self.boundingBox.size.width/2.0) -
                                       (_awarenessProximity.size.width/2.0),
                                    position.y + (self.boundingBox.size.height/2.0) -
                                       (_awarenessProximity.size.height/2.0));
   [super setPosition:position];
}

- (void)setState:(EnemyState)state
{
   switch (state)
   {
      case e_SLEEPING:
         self.texture = _sleepingTexture;
         _shouldCalculateNewPath = NO;
         [self setAwarenessProximityWithSize:ENEMY_AWARENESS_PROXIMITY_DEFAULT];
         break;
      case e_WANDERING:
         self.texture = _wanderingTexture;
         self.velocity = ccp(.5,.5);
         self.maxVelocity = ccp(.5,.5);
         [self setAwarenessProximityWithSize:ENEMY_AWARENESS_PROXIMITY_DEFAULT];
         break;
      case e_CHASING:
         self.texture = _chasingTexture;
         self.maxVelocity = ccp(.8,.8);
         [self setAwarenessProximityWithSize:ENEMY_AWARENESS_PROXIMITY_CHASING];
      default:
         break;
   }
   _state = state;
}

- (void)examineAwarenessProximityForCharacter:(MMCharacter *)character
{
   switch (_state)
   {
      case e_SLEEPING:
         if (CGRectIntersectsRect(_awarenessProximity, character.boundingBox))
         {
            self.state = e_CHASING;
            _target = character.currentTile;
            _shouldCalculateNewPath = YES;
            [self update:0];
         }
         break;
      case e_WANDERING:
         if (CGRectIntersectsRect(_awarenessProximity, character.boundingBox))
         {
            _target = character.currentTile;
            self.state = e_CHASING;
         }
         break;
      case e_CHASING:
         if (!(CGRectIntersectsRect(_awarenessProximity, character.boundingBox)))
         {
            _target = [[MMGameController sharedController].level.maze getRandomTile];
            self.state = e_WANDERING;
         }
         break;
      default:
         break;
   }
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
               _target = [[MMGameController sharedController].level.maze getRandomTile];

            NSLog(@"%@ wandering to %@", self.travelerKey, NSStringFromCGPoint(_target.position));
            [self beginExecutingCurrentPath];
         }
         default:
            break;
      }
      _shouldCalculateNewPath = NO;
   }
}

- (BOOL)stopMoving
{
   switch (self.state)
   {
      case e_WANDERING:
         break;
      case e_CHASING:
         // if enemy found player, then stop
         // else, start wandering
         self.state = e_WANDERING;
         break;
      default:
         break;
   }
   
   return YES;
}

-(void)evaluateStateAndPotentiallyCalculatePathInTheFuture
{
   switch (_state)
   {
      case e_CHASING:
         if (self.shouldMove)
            self.shouldCalculateNewPath = YES;
         break;

      case e_WANDERING:
         if (self.shouldMove && [self moveStackIsEmpty])
            self.shouldCalculateNewPath = YES;
      default:
         break;
   }
}

- (void)updatePositionForTile:(MMTile *)nextTile
                   atLocation:(CGPoint)nextTileLocation
              andMazeMovement:(BOOL)mazeMoving
{
   [super updatePositionForTile:nextTile
                     atLocation:nextTileLocation
                   mazeMovement:mazeMoving];

   if ([self moveStackIsEmpty])
      [self stopMoving];
}

- (void)updateCurrentTileForMazeMovement:(BOOL)mazeMoving
{
   MMTile *nextTile = [self.currentTile getAdjacentTileForDirection:self.direction];
   nextTile.isActive = YES;

   [super updateCurrentTileForMazeMovement:mazeMoving];
}

@end
