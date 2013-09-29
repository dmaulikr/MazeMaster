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

@synthesize playerSprite = _playerSprite;

#define MAX_VELOCITY 1.0

- (void)setupVariables
{
   _windowSize = [[CCDirector sharedDirector] winSize];
   _tileSize = CGSizeMake(44, 44);
   _outsideEdgePadding = 0;

   _verticalCenterRange = NSMakeRange(_windowSize.width/2.0 - _tileSize.width/2.0,
                                      _tileSize.width/2.0);
   _horizontalCenterRange = NSMakeRange(_windowSize.height/2.0 - _tileSize.height/2.0,
                                      _tileSize.height/2.0);
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
//   _playerSprite.position = ccp(_tileSize.width/2 - _playerSprite.boundingBox.size.width/2,
//                                _tileSize.height/2 - _playerSprite.boundingBox.size.height/2);
//   _playerSprite.position = ccp(150, 150);
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
   ccColor4B translucentWhite = ccc4(255,255,255,100);
	if (self = [super initWithColor:translucentWhite])
   {
      [self setupVariables];
      [self addBackButton];
      [self setupPlayer];

//      [self setupOffsetForPlayerAndMaze];

      [self setTouchEnabled:YES];
      [self scheduleUpdate];
	}
	return self;
}

- (id)initWithMaze:(MazeLayer *)mazeLayer
{
   if (self = [self init])
   {
      [self setupMazeLayer:mazeLayer];
   }
   return self;
}

- (void)dealloc
{
   [super dealloc];
}

- (void)update:(ccTime)delta
{
   [self movePlayer];
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

- (BOOL)yValuePastNorthMazeBound:(int)yValue
{
   float northBound = (_mazeLayer.mazeSize.height < _windowSize.height) ?
   _mazeLayer.mazeSize.height : _windowSize.height;

   return (yValue >= northBound);
}

- (BOOL)yValuePastSouthMazeBound:(int)yValue
{
   return (yValue < _outsideEdgePadding);
}

- (BOOL)xValuePastEastMazeBound:(int)xValue
{
   float eastBound = (_mazeLayer.mazeSize.width < _windowSize.width) ?
   _mazeLayer.mazeSize.width + _outsideEdgePadding : _windowSize.width;
   return (xValue >= eastBound);
}

- (BOOL)xValuePastWestMazeBound:(int)xValue
{
   return (xValue < _outsideEdgePadding);
}

- (BOOL)playerPositionInMazeBounds:(CGPoint)position
{
   float playerHeight = _playerSprite.boundingBox.size.height;
   float playerWidth = _playerSprite.boundingBox.size.width;
   
   // north
   if ([self yValuePastNorthMazeBound:(position.y + playerHeight)])
      return NO;
   // south
   if ([self yValuePastSouthMazeBound:position.y])
      return NO;
   // east
   if ([self xValuePastEastMazeBound:(position.x + playerWidth)])
      return NO;
   // west
   if ([self xValuePastWestMazeBound:position.x])
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

- (CGPoint)getXYForPlayerDirection:(PlayerDirection)direction
{
   float x, y;
   GameController *gameController = [GameController gameController];
   
   gameController.playerDirection = direction;
   
   if ( _playerSprite.playerVelocity.x <= MAX_VELOCITY )
   {
      _playerSprite.playerVelocity = CGPointMake(_playerSprite.playerVelocity.x + 0.3, _playerSprite.playerVelocity.y + 0.3);
   }
   
   switch ( direction )
   {
      case e_NORTH:
         x = 0;
         y = _playerSprite.playerVelocity.y;
         break;
      case e_EAST:
         x = _playerSprite.playerVelocity.x;
         y = 0;
         break;
      case e_SOUTH:
         x = 0;
         y = -_playerSprite.playerVelocity.y;
         break;
      case e_WEST:
         x = -_playerSprite.playerVelocity.x;
         y = 0;
         break;
         
      default:
         break;
   }
   return CGPointMake(x,y);
}

- (void)movePlayer
{
   GameController *gameController = [GameController gameController];
   CGPoint destination;
   
   if ( gameController.isPlayerMoving )
   {
      CGPoint directionPoint = [self getXYForPlayerDirection:gameController.playerDirection];
      destination = [self getDestinationPointForX:directionPoint.x
                                                        y:directionPoint.y];
      // _moveMaze is on when the maze moves instead of the player
      // _playerSprite.destination is
      float diffX;
      float diffY;
      if( _moveMaze )
      {
         diffX = _mazeLayer.position.x - destination.x;
         diffY = _mazeLayer.position.y - destination.y;
         //         _playerSprite.relativePosition = _playerSprite.destination;
      }
      else
      {
         diffX = destination.x - _playerSprite.position.x;
         diffY = destination.y - _playerSprite.position.y;
//         _playerSprite.relativePosition = _playerSprite.destination;
      }
      
      CCNode *moveableObect = (_moveMaze ? _mazeLayer : _playerSprite);
      moveableObect.position = destination;
      
      CGPoint absolutePosition = ccp(_playerSprite.absolutePosition.x + diffX,
                                     _playerSprite.absolutePosition.y + diffY);
//      NSLog(@"absolutePosition: %@", NSStringFromCGPoint(_playerSprite.absolutePosition));
//      NSLog(@"diffX: %f  diffY: %f", diffX, diffY);
      
      _playerSprite.absolutePosition = absolutePosition;
      
      Tile *currentTile = gameController.level.maze.tileWithPlayer;
   //   NSLog(@"player bounding box: %@", NSStringFromCGRect(_playerSprite.boundingBox));
      [gameController.level.maze updateTileContainingPlayer:_tileSize withPosition:_playerSprite.absolutePosition withPlayer:_playerSprite];
      if ( currentTile != gameController.level.maze.tileWithPlayer )
      {
         // turn the playerIsMoving variable off if plyaerShouldMove is false
         if ( gameController.playerShouldMove == NO )
         {
            gameController.isPlayerMoving = NO;
//            Tile *tileWithPlayer = gameController.level.maze.tileWithPlayer;
//            _playerSprite.position = ccp(tileWithPlayer.position.x + _tileSize.width / 2 - _playerSprite.boundingBox.size.width / 2,
//                                         tileWithPlayer.position.y + _tileSize.height / 2 - _playerSprite.boundingBox.size.height / 2);
         }
      }
   }


}

// Helper class method that creates a Scene with the StartLayer as the only child.
+ (CCScene *)scene
{
   GameController *gameController = [GameController gameController];
   
   MazeLayer *mazeLayer = [[[MazeLayer alloc] initWithMaze:gameController.level.maze] autorelease];
   GameLayer *gameLayer = [[[GameLayer alloc] initWithMaze:mazeLayer] autorelease];
   ControlsLayer *controlsLayer = [ControlsLayer node];

   // TODO: get the tag to work, currently does nothing. Then we could take
   // the gameLayer out of the controlsLayer class
   gameLayer.tag = 1;
   // currently needed to access the game layer
   gameController.gameLayer = gameLayer;

	CCScene *scene = [CCScene node];
   [scene addChild:mazeLayer];
	[scene addChild:gameLayer];
	[scene addChild:controlsLayer];
   
	return scene;
}

@end
