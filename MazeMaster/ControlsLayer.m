//
//  ControlsLayer.m
//  MazeMaster
//
//  Created by Justin Fila on 8/19/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "ControlsLayer.h"
#import "CCNode+SFGestureRecognizers.h"
#import "GameController.h"
#import "Player.h"

static NSString * const UIGestureRecognizerNodeKey = @"UIGestureRecognizerNodeKey";

@implementation ControlsLayer

-(id) init
{
   if ( self = [super init] )
   {
      [self setTouchEnabled:YES];
      
      // add the different gesture recognizers for the 4 directions
      UISwipeGestureRecognizer *recognizer;
      
      recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
      [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
      [self addGestureRecognizer:recognizer];
      [recognizer release];
      
      recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
      [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
      [self addGestureRecognizer:recognizer];
      [recognizer release];
      
      recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
      [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
      [self addGestureRecognizer:recognizer];
      [recognizer release];
      
      recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
      [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
      [self addGestureRecognizer:recognizer];
      [recognizer release];
      
   }
   
   return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
            shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
   return YES;
}

// handles the swipe for each direction
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
   // TODO: that'd be nice to get the tags working instead of using the game controller...
   
   GameController *gameController = [GameController sharedController];
   
   PlayerDirection direction;
   switch (recognizer.direction)
   {
      case UISwipeGestureRecognizerDirectionRight:
         direction = e_EAST;
         break;
         
      case UISwipeGestureRecognizerDirectionLeft:
         direction = e_WEST;
         break;
         
      case UISwipeGestureRecognizerDirectionUp:
         direction = e_NORTH;
         break;
         
      case UISwipeGestureRecognizerDirectionDown:
         direction = e_SOUTH;
         break;
         
      default:
         break;
   }
   
   if ([gameController swipeStackIsEmpty] &&
       gameController.playerDirection == e_NONE)
   {
      gameController.playerDirection = direction;
   }
   else if ([gameController topSwipeStack] != direction)
   {
      [gameController pushSwipeStack:direction];
   }
   
   // only call the move player function if it is the first swipe (because it will
   // be called automatically at the end of the move)
   if ( !gameController.isPlayerMoving )
   {
      if ( [gameController playerCanMoveFromTile:gameController.level.maze.tileWithPlayer] )
      {
         gameController.isPlayerMoving = YES;
         gameController.playerShouldMove = YES;
      }
   }
}

-(void) ccTouchesEnded:(NSSet *)touches
             withEvent:(UIEvent *)event
{
   // TODO decelerate
   GameController * gameController = [GameController sharedController];
   gameController.playerShouldMove = NO;
//   gameController.gameLayer.playerSprite.playerVelocity = CGPointMake(1.0, 1.0);
}

-(void) dealloc
{
   [super dealloc];
}

@end
