//
//  GameLayer.m
//  MazeMaster
//
//  Created by Gregory Klein on 8/6/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "GameLayer.h"

#import "ControlsLayer.h"
#import "GameController.h"
#import "Level.h"
#import "LevelSelectLayer.h"
#import "MazeLayer.h"
#import "Player.h"
#import "Tile.h"

@implementation GameLayer

- (void)setupVariables
{
   _windowSize = [[CCDirector sharedDirector] winSize];
   _tileSize = CGSizeMake(44, 44);
   _subtileSize = CGSizeMake(20, 20);

   _outsideEdgePadding = 20;
   _insideEdgePadding = 5;

   _verticalCenterRange = NSMakeRange(_windowSize.width/2.0 - _tileSize.width/2.0,
                                      _tileSize.width);
   _horizontalCenterRange = NSMakeRange(_windowSize.height/2.0 - _tileSize.height/2.0,
                                      _tileSize.height);
}

- (void)addBackButton
{
   CGSize windowSize = [[CCDirector sharedDirector] winSize];

   CCMenuItem *backButton = [CCMenuItemImage itemWithNormalImage:@"Arrow.png"
                                                   selectedImage:@"Arrow.png"];
   backButton.scale = .25;
   backButton.rotation = 180;
   backButton.position = ccp(30, windowSize.height - 30);
   [backButton setBlock:^(id sender)
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

- (void)setupPlayer
{
   _playerSprite = [Player playerWithFile:@"astronaut_front.png"];
   _playerSprite.anchorPoint = CGPointZero;
   _playerSprite.scale = 1.6;
   [self addChild:_playerSprite];
}

- (void)setupMazeLayer:(MazeLayer *)mazeLayer
{
   _mazeLayer = mazeLayer;
   _mazeLayer.anchorPoint = CGPointZero;
   _moveMaze = NO;
}

- (void)setupOffsetForPlayerAndMaze
{
   float playerWidth = _playerSprite.boundingBox.size.width;
   float playerHeight = _playerSprite.boundingBox.size.height;
   _playerSprite.position = ccp((_tileSize.width - playerWidth)/2.0 + _outsideEdgePadding,
                                (_tileSize.height - playerHeight)/2.0 + _outsideEdgePadding);
   
   _mazeLayer.position = ccp(_outsideEdgePadding,
                             _outsideEdgePadding);
}

- (id)init
{
	if (self = [super initWithColor:ccc4(255,255,255,100)])
   {
      [self setupVariables];
      [self addBackButton];
      [self setupPlayer];

      [self setupOffsetForPlayerAndMaze];

      [self setTouchEnabled:YES];
      [self scheduleUpdate];
	}
	return self;
}

- (id)initWithMaze:(MazeLayer *)mazeLayer
{
   [self setupMazeLayer:mazeLayer];
   return [self init];
}

- (void)dealloc
{
   [super dealloc];
}

-(void) update:(ccTime)delta
{
   [[GameController gameController] movePlayer];
}

- (BOOL)playerIsHorizontallyCenteredOnScreen
{
   return NSLocationInRange(_playerSprite.position.x,
                            _verticalCenterRange);
}

- (BOOL)playerIsVerticallyCenteredOnScreen
{
   return NSLocationInRange(_playerSprite.position.y,
                            _horizontalCenterRange);
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
         if ((northMazeBound > _windowSize.height) &&
             [self playerIsVerticallyCenteredOnScreen])
            retVal = YES;
         break;
      }
      case e_SOUTH:
      {
         float southMazeBound = _mazeLayer.position.y;
         if ((southMazeBound < _outsideEdgePadding) &&
             [self playerIsVerticallyCenteredOnScreen])
            retVal = YES;
         break;
      }
      case e_EAST:
      {
         float eastMazeBound = _mazeLayer.position.x + _mazeLayer.mazeSize.width;
         if ((eastMazeBound > _windowSize.width) &&
             [self playerIsHorizontallyCenteredOnScreen])
            retVal = YES;
         break;
      }
      case e_WEST:
      {
         float westMazeBound = _mazeLayer.position.x;
         if ((westMazeBound < _outsideEdgePadding) &&
             [self playerIsHorizontallyCenteredOnScreen])
            retVal = YES;
         break;
      }
      default:
         break;
   }
   return retVal;
}

- (BOOL)yValuePastNorthBound:(int)yValue
{
   return (yValue >= _windowSize.height);
}

- (BOOL)yValuePastSouthBound:(int)yValue
{
   return (yValue < _outsideEdgePadding);
}

- (BOOL)xValuePastEastBound:(int)xValue
{
   return (xValue >= _windowSize.width);
}

- (BOOL)xValuePastWestBound:(int)xValue
{
   return (xValue < _outsideEdgePadding);
}

- (BOOL)playerPositionInMazeBounds:(CGPoint)position
{
   float playerHeight = _playerSprite.boundingBox.size.height;
   float playerWidth = _playerSprite.boundingBox.size.width;
   
   // north
   if ([self yValuePastNorthBound:(position.y + playerHeight)])
      return NO;
   // south
   if ([self yValuePastSouthBound:position.y])
      return NO;
   // east
   if ([self xValuePastEastBound:(position.x + playerWidth)])
      return NO;
   // west
   if ([self xValuePastWestBound:position.x])
      return NO;

   return YES;
}

- (CGPoint)getDestinationPointForX:(int)x
                                y:(int)y
{
   CGPoint destination;
   PlayerDirection direction = [GameController gameController].playerDirection;
   
   if ([self mazeShouldMoveForPlayerDirection:direction])
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

- (void)movePlayer
{
   CCNode *moveableObect = (_moveMaze ? _mazeLayer : _playerSprite);
   GameController *gameController = [GameController gameController];
   
   if ( gameController.isPlayerMoving )
   {
      int x, y;
      
      switch ( gameController.playerDirection )
      {
         case e_NORTH:
            x = 0;
            y = 1;
            break;
         case e_EAST:
            x = 1;
            y = 0;
            break;
         case e_SOUTH:
            x = 0;
            y = -1;
            break;
         case e_WEST:
            x = -1;
            y = 0;
            break;
            
         default:
            break;
      }
   [moveableObect setPosition:CGPointMake(_playerSprite.position.x + x, _playerSprite.position.y + y)];
   }
   
}
// TODO: what if the player hits an enemy half way through a move?
-(void) movePlayerByX:(int)x andY:(int)y
{
   CGPoint destination = [self getDestinationPointForX:x y:y];
   CCMoveTo *moveAction = [CCMoveTo actionWithDuration:.35f
                                              position:destination];
   CCCallFunc *actionMoveDone = [CCCallFuncN actionWithTarget:self
                                                     selector:@selector(finishedMovingPlayer:)];
   CCSequence *actionSequence = [CCSequence actions:moveAction, actionMoveDone, nil];

   [(_moveMaze ? _mazeLayer : _playerSprite) runAction:actionSequence];
}

// called when player is done moving to a tile
-(void) finishedMovingPlayer:(id)sender
{
   [self movePlayer];
}

// Helper class method that creates a Scene with the StartLayer as the only child.
+ (CCScene *)scene
{
	CCScene *scene = [CCScene node];

   int rows = [GameController gameController].level.maze.mazeDimensions.rows;
   int cols = [GameController gameController].level.maze.mazeDimensions.cols;
   MazeLayer *mazeLayer = [[[MazeLayer alloc] initWithRows:rows
                                                   columns:cols] autorelease];
   
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
