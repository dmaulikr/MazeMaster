//
//  ControlsLayer.m
//  MazeMaster
//
//  Created by Justin Fila on 8/19/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "ControlsLayer.h"
#import "CCNode+SFGestureRecognizers.h"
#import "DoubleTouchDownRecognizer.h"
#import "GameController.h"
#import "GameLayer.h"
#import "LevelSelectLayer.h"
#import "Level.h"
#import "Player.h"

@implementation ControlsLayer

- (void)addBackButton
{
   CGSize windowSize = [[CCDirector sharedDirector] winSize];

   CCMenuItem *backButton = [CCMenuItemImage itemWithNormalImage:@"Arrow.png"
                                                   selectedImage:@"Arrow.png"];
   backButton.scale = .25;
   backButton.rotation = 180;
   backButton.position = ccp(30, windowSize.height - 30);
   [backButton setBlock:
    ^(id sender)
    {
       CCDirector *director = [CCDirector sharedDirector];
       CCScene *levelSelectScene = [LevelSelectLayer scene];
       [director replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5
                                                                     scene:levelSelectScene]];
    }];

   CCMenu *backButtonMenu = [CCMenu menuWithItems:backButton, nil];
   backButtonMenu.position = CGPointZero;

   [self addChild:backButtonMenu];
}

- (void)setupMultiTouchRecognizer
{
   DoubleTouchDownRecognizer *recognizer;
   recognizer = [[DoubleTouchDownRecognizer alloc] initWithTarget:self
                                                           action:@selector(handleTwoFingerPress:)];
   recognizer.delegate = self;
   [self addGestureRecognizer:recognizer];
   [recognizer release];
}

- (void)setupSwipeRecognizer
{
   UISwipeGestureRecognizer *recognizer;
   // add the different gesture recognizers for the 4 directions
   recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(handleSwipeFrom:)];
   [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
   [self addGestureRecognizer:recognizer];
   [recognizer release];

   recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(handleSwipeFrom:)];
   [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
   [self addGestureRecognizer:recognizer];
   [recognizer release];

   recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(handleSwipeFrom:)];
   [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
   [self addGestureRecognizer:recognizer];
   [recognizer release];

   recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(handleSwipeFrom:)];
   [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
   [self addGestureRecognizer:recognizer];
   [recognizer release];
}

-(id) init
{
   if (self = [super init])
   {
      _touchEnabled = YES;
      [self setupSwipeRecognizer];
      [self setupMultiTouchRecognizer];
      [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self
                                                                priority:INT_MIN+1
                                                         swallowsTouches:NO];
      [self addBackButton];
   }
   return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
   return YES;
}

// handles the swipe for each direction
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
   // TODO: that'd be nice to get the tags working instead of using the game controller...
   
   GameController *gameController = [GameController sharedController];
   
   CharacterDirection direction;
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
   
   if ([gameController.gameLayer.playerSprite moveStackIsEmpty] &&
       gameController.gameLayer.playerSprite.direction == e_NONE)
   {
      gameController.gameLayer.playerSprite.direction = direction;
   }
   else if ([gameController.gameLayer.playerSprite topMoveStack] != direction)
   {
      [gameController.gameLayer.playerSprite pushMoveStack:direction];
   }
   
   // only call the move player function if it is the first swipe (because it will
   // be called automatically at the end of the move)
   if ( !gameController.gameLayer.playerSprite.isMoving )
   {
      if ( [gameController canMoveFromTile:gameController.gameLayer.playerSprite.currentTile
                               inDirection:gameController.gameLayer.playerSprite.direction] )
      {
         gameController.gameLayer.playerSprite.isMoving = YES;
         gameController.gameLayer.playerSprite.shouldMove = YES;
      }
   }
}

- (void)handleTwoFingerPress:(UITapGestureRecognizer *)recognizer
{
   [GameController sharedController].gameLayer.playerSprite.shouldMove = NO;
}

- (void)handleSingleTap:(NSArray *)touchPoint
{
   CGPoint location = ccp([[touchPoint objectAtIndex:0] integerValue],
                          [[touchPoint objectAtIndex:1] integerValue]);

   if ([_delegate respondsToSelector:@selector(handleTapAtLocation:)])
      [_delegate handleTapAtLocation:location];
}

- (void)handleDoubleTap:(NSArray *)touchPoint
{
   CGPoint location = ccp([[touchPoint objectAtIndex:0] integerValue],
                          [[touchPoint objectAtIndex:1] integerValue]);

   if ([_delegate respondsToSelector:@selector(handleDoubleTapAtLocation:)])
      [_delegate handleDoubleTapAtLocation:location];
}

- (BOOL)ccTouchBegan:(UITouch *)touch
           withEvent:(UIEvent *)event
{
   return YES;
}

- (void)ccTouchEnded:(UITouch *)touch
             withEvent:(UIEvent *)event
{
   CGPoint location = [touch locationInView:touch.view];
   location = [[CCDirector sharedDirector] convertToGL:location];

   switch (touch.tapCount)
   {
      case 1:
         _lastTouchLocation = ccp(location.x, location.y);
         [self performSelector:@selector(handleSingleTap:)
                    withObject:[NSArray arrayWithObjects:
                                [NSNumber numberWithInt:_lastTouchLocation.x],
                                [NSNumber numberWithInt:_lastTouchLocation.y], nil]
                    afterDelay:.165];
         break;
      case 2:
         [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                  selector:@selector(handleSingleTap:)
                                                    object:[NSArray arrayWithObjects:
                                                            [NSNumber numberWithInt:_lastTouchLocation.x],
                                                            [NSNumber numberWithInt:_lastTouchLocation.y],
                                                            nil]];
         [self handleDoubleTap:[NSArray arrayWithObjects:[NSNumber numberWithInt:location.x],
                                                         [NSNumber numberWithInt:location.y],
                                                         nil]];
         break;
      default:
         break;
   }
}

-(void) dealloc
{
   [super dealloc];
}

@end
