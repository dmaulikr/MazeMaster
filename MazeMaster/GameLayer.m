//
//  GameLayer.m
//  MazeMaster
//
//  Created by Gregory Klein on 8/6/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "GameLayer.h"
#import "GameController.h"
#import "Tile.h"
#import "MazeLayer.h"
#import "LevelSelectLayer.h"
#import "ControlsLayer.h"

@implementation GameLayer

#define SUBTILE_ROW_MAX 3
#define SUBTILE_COL_MAX 3

- (void)addBackButton
{
   CGSize windowSize = [[CCDirector sharedDirector] winSize];

   CCMenuItem *backButton = [CCMenuItemImage itemWithNormalImage:@"Arrow.png"
                                                   selectedImage:@"Arrow.png"];
   [backButton setBlock:^(id sender)
   {
      CCDirector *director = [CCDirector sharedDirector];
      CCScene *levelSelectScene = [LevelSelectLayer scene];
      [director replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5
                                                                    scene:levelSelectScene]];
   }];

   backButton.scale = .25;
   backButton.rotation = 180;
   backButton.position = ccp(30, windowSize.height - 30);
   CCMenu *backButtonMenu = [CCMenu menuWithItems:backButton, nil];
   backButtonMenu.position = CGPointZero;

   [self addChild:backButtonMenu];
}

// used for testing, should be removed soon
- (void)setupDimensions
{
   _windowSize = [[CCDirector sharedDirector] winSize];
   _tileSize = CGSizeMake(102, 102);
   _subtileSize = CGSizeMake(20, 20);

   _outsideEdgePadding = 10;
   _insideEdgePadding = 5;
}

- (void)setupPlayer
{
   _playerSprite = [Player playerWithFile:@"astronaut_front.png"];
   _playerSprite.anchorPoint = CGPointZero;
   _playerSprite.position = ccp(_windowSize.width/2.0, _windowSize.height/2.0);
   _playerSprite.scale = 2;
   [self addChild:_playerSprite];
}

- (id)init
{
	if (self = [super init])
   {
      [self setupDimensions];
      [self setupPlayer];
      [self addBackButton];

      [self setTouchEnabled:YES];
      [self scheduleUpdate];
	}
	return self;
}

- (id)initWithMaze:(MazeLayer *)mazeLayer
{
   _mazeLayer = mazeLayer;
   _mazeLayer.anchorPoint = CGPointZero;
   _moveMaze = NO;
   NSLog(@"_mazeLayer.position: %@", NSStringFromCGPoint([_mazeLayer position]));
   return [self init];
}

- (void)dealloc
{
   [_mazeLayer release];
   [super dealloc];
}

// called when player is done moving to a tile
-(void) finishedMovingPlayer:(id)sender
{
   [[GameController gameController] movePlayer];
}

- (BOOL)playerIsHorizontallyCenteredOnScreen
{
   return (_playerSprite.position.x == _windowSize.width/2.0);
}

- (BOOL)playerIsVerticallyCenteredOnScreen
{
   return (_playerSprite.position.y == _windowSize.height/2.0);
}

- (BOOL)playerIsCenteredOnScreen
{
   return ([self playerIsHorizontallyCenteredOnScreen] &&
           [self playerIsVerticallyCenteredOnScreen]);
}

- (BOOL)mazeShouldMoveForPlayerDirection:(PlayerDirection)direction
{
   BOOL retVal = NO;
   switch (direction)
   {
      case e_NORTH:
      {
         float northMazeBound = _mazeLayer.position.y + _mazeLayer.mazeSize.height;
         if ((northMazeBound > _windowSize.height) && [self playerIsVerticallyCenteredOnScreen])
            retVal = YES;
         break;
      }

      case e_SOUTH:
      {
         float southMazeBound = _mazeLayer.position.y;
         if ((southMazeBound < _outsideEdgePadding) && [self playerIsVerticallyCenteredOnScreen])
            retVal = YES;
         break;
      }

      case e_EAST:
      {
         float eastMazeBound = _mazeLayer.position.x + _mazeLayer.mazeSize.width;
         if ((eastMazeBound > _windowSize.width) && [self playerIsHorizontallyCenteredOnScreen])
            retVal = YES;
         break;
      }

      case e_WEST:
      {
         float westMazeBound = _mazeLayer.position.x;
         if ((westMazeBound < _outsideEdgePadding) && [self playerIsHorizontallyCenteredOnScreen])
            retVal = YES;
         break;
      }

      default:
         break;
   }
   return retVal;
}

- (BOOL)playerPositionInMazeBounds:(CGPoint)position
{
   int padding = (_outsideEdgePadding + _insideEdgePadding);
   
   // north
   if ((position.y + _playerSprite.boundingBox.size.height/2.0) > (_windowSize.height - _outsideEdgePadding))
      return NO;

   // south
   if ((position.y - _playerSprite.boundingBox.size.height/2.0) < _outsideEdgePadding)
      return NO;

   // east
   if ((position.x + _playerSprite.boundingBox.size.width) > (_windowSize.width - padding))
      return NO;

   // west
   if (position.x < padding)
      return NO;

   return YES;
}

- (CGPoint)getDestinationPointFor:(int)x
                                y:(int)y
{
   CGPoint destination;

   PlayerDirection playerDirection = [GameController gameController].playerDirection;
   if ([self mazeShouldMoveForPlayerDirection:playerDirection])
   {
      _moveMaze = YES;
      destination = CGPointMake(_mazeLayer.position.x - x,
                                _mazeLayer.position.y - y);
   }
   else
   {
      _moveMaze = NO;
      destination = CGPointMake(_playerSprite.position.x + x,
                                _playerSprite.position.y + y);

      if (![self playerPositionInMazeBounds:destination])
         destination = _playerSprite.position;
   }
   return destination;
}

// TODO: what if the player hits an enemy half way through a move?
-(void) movePlayerByX:(int)x andY:(int)y
{
   CGPoint destination = [self getDestinationPointFor:x y:y];
   
   CCMoveTo *moveAction = [CCMoveTo actionWithDuration:.35f position:destination];
   CCCallFunc *actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(finishedMovingPlayer:)];
   CCSequence *actionSequence = [CCSequence actions:moveAction, actionMoveDone, nil];

   if (_moveMaze)
      [_mazeLayer runAction:actionSequence];
   else
      [_playerSprite runAction:actionSequence];
}

// Helper class method that creates a Scene with the StartLayer as the only child.
+ (CCScene *)scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];

   int rows = [GameController gameController].level.maze.mazeDimensions.rows;
   int cols = [GameController gameController].level.maze.mazeDimensions.cols;
   MazeLayer *mazeLayer = [[[MazeLayer alloc] initWithRows:rows columns:cols] autorelease];
   
   GameLayer *gameLayer = [[[GameLayer alloc] initWithMaze:mazeLayer] autorelease];
   ControlsLayer *controlsLayer = [ControlsLayer node];

   // TODO: get the tag to work, currently does nothing. Then we could take
   // the gameLayer out of the controlsLayer class
   gameLayer.tag = 1;
   // currently needed to access the game layer
   [GameController gameController].gameLayer = gameLayer;

   [scene addChild:mazeLayer];
	[scene addChild:gameLayer];
	[scene addChild:controlsLayer];

	return scene;
}

@end
