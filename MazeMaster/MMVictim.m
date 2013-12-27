//
//  MMVictim.m
//  MazeMaster
//
//  Created by Justin Fila on 12/18/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "MMVictim.h"
#import "MMGameController.h"
#import "MMGameLayer.h"
#import "MMPlayer.h"
#import "MMTile.h"

@interface MMVictim()
{
   // TODO-M: do we really need a stack for this?
   NSMutableArray *_delayMoveStack;
}
@end

@implementation MMVictim

- (id) initWithFile:(NSString *)filename
{
   if (self = [super initWithFile:filename])
   {
      //[self scheduleUpdate];
      //[self setupTextures];
      _delayMoveStack = [NSMutableArray new];
   }
   return self;
}

- (void) attack
{
   NSLog(@"victim attack not implemented");
}

- (BOOL)stopMoving
{
   if (self.direction != e_DUMMY)
   {
      // TODO-MM: this position set wont work if the victim moves forever, because it only gets called on stop
      self.position = ccp(self.currentTile.tileSprite.position.x + self.offset.x,
                          self.currentTile.tileSprite.position.y + self.offset.y);
      return [super stopMoving];
   }
   
   return NO;
}

- (BOOL)parentStoppedMoving
{
   return ![MMGameController sharedController].gameLayer.playerSprite.isMoving;
}

- (void) pushMoveStack:(CharacterDirection)direction
{
   // push to the delayed move stack
   [_delayMoveStack insertObject:[NSNumber numberWithInt:direction] atIndex:0];
}

- (void) moveFromDelayToMoveStack
{
   CharacterDirection direction = e_NONE;
   if (_delayMoveStack.count)
   {
      NSNumber *directionNumber = [_delayMoveStack lastObject];
      direction = (CharacterDirection)directionNumber.intValue;
      [super pushMoveStack:direction];
      [_delayMoveStack removeLastObject];
      NSLog(@"next direction: %d", direction);
   }
}

-(CharacterDirection) topMoveStack
{
   CharacterDirection retDir = [super topMoveStack];
   return retDir;
}

- (CharacterDirection) popMoveStack
{
   CharacterDirection retDir = [super popMoveStack];
   [self moveFromDelayToMoveStack];
   return retDir;
}

- (BOOL) moveStackIsEmpty
{
   BOOL ret = [super moveStackIsEmpty];
   if (ret)
      [self moveFromDelayToMoveStack];
   
   return ret;
}

- (void) testDelayStack
{
   [self pushMoveStack:e_EAST];
   [self pushMoveStack:e_SOUTH];
   [self pushMoveStack:e_WEST];
   [self pushMoveStack:e_NORTH];
   [self pushMoveStack:e_EAST];
   [self pushMoveStack:e_SOUTH];
   [self pushMoveStack:e_WEST];
   [self pushMoveStack:e_NORTH];
   [self pushMoveStack:e_EAST];
   [self pushMoveStack:e_SOUTH];
   [self pushMoveStack:e_WEST];
   [self pushMoveStack:e_NORTH];
}

- (void)clearMoveStack
{
   if (![super moveFromMoveStackTo:_delayMoveStack])
   {
      if (self.direction != e_NONE)
         [self pushMoveStack:self.direction];
   }
   [super clearMoveStack];
}

+ (MMVictim *)victimWithFile:(NSString *)filename
{
   // TODO: this is weird
   return (MMVictim *)[super characterWithFile:filename];
}

- (void)setState:(VictimState)state
{
   switch (state)
   {
      case e_WAITING:
         self.velocity = ccp(0, 0);
         self.maxVelocity = ccp(0, 0);
         break;
      case e_FOLLOWING:
         self.velocity = [MMGameController sharedController].gameLayer.playerSprite.velocity;
         self.maxVelocity = [MMGameController sharedController].gameLayer.playerSprite.maxVelocity;
         break;
      case e_SAVED:
         self.velocity = ccp(0, 0);
         self.maxVelocity = ccp(0,0);
      default:
         break;
   }
   _state = state;
}

- (void) dealloc
{
   [_delayMoveStack release];
   [super dealloc];
}

@end
