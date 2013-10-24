
//
//  GameLayer.m
//  MazeMaster
//
//  Created by Gregory Klein on 8/6/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "GameLayer.h"

#import "GameController.h"
#import "Level.h"
#import "LevelSelectLayer.h"
#import "MazeLayer.h"
#import "Player.h"
#import "Tile.h"

#include "PathFinder.h"

struct Opaque
{
   PathFinder *pathFinder;
};

@implementation GameLayer

#define MAX_VELOCITY 1.7

- (void)setupVariables
{
   _windowSize = [[CCDirector sharedDirector] winSize];
   _tileSize = CGSizeMake(44, 44);
   _outsideEdgePadding = 0;
   _verticalCenterRange = NSMakeRange(_windowSize.width/2.0 - _tileSize.width/4.0,
                                      _tileSize.width/2.0);
   _horizontalCenterRange = NSMakeRange(_windowSize.height/2.0 - _tileSize.height/4.0,
                                      _tileSize.height/2.0);
   _opaque = new struct Opaque;
   _opaque->pathFinder = new PathFinder();
}

- (void)setupPlayer
{
   _playerSprite = [Player playerWithFile:@"astronaut_front.png"];
   _playerSprite.anchorPoint = CGPointZero;
   _playerSprite.scale = 1.8;

   _xPlayerOffset = (_tileSize.width/2.0) - (_playerSprite.boundingBox.size.width/2.0);
   _yPlayerOffset = (_tileSize.height/2.0) - (_playerSprite.boundingBox.size.height/2.0);

   _playerSprite.position = ccp(_xPlayerOffset, _yPlayerOffset);
   _playerSprite.absolutePosition = ccp(_xPlayerOffset, _yPlayerOffset);

   Maze *maze = [GameController sharedController].level.maze;
   [maze updateTileContainingPlayerWithPlayerPosition:_playerSprite.absolutePosition
                                          forTileSize:_tileSize];
   [self addChild:_playerSprite];
}

- (void)setupMazeLayer:(MazeLayer *)mazeLayer
{
   _mazeLayer = mazeLayer;
   _mazeLayer.anchorPoint = CGPointZero;
   _moveMaze = NO;
}

- (id)init
{
	if (self = [super init])
   {
      [self setupVariables];
      [self setupPlayer];
      [[GameController sharedController].level addEnemiesToLayer:self];
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
   delete _opaque->pathFinder;
   [super dealloc];
}

- (void)update:(ccTime)delta
{
   [self movePlayer];
   [self moveEnemies];
}

- (BOOL)playerIsHorizontallyCenteredOnScreen
{
   return NSLocationInRange(_playerSprite.position.x + _playerSprite.boundingBox.size.width/2.0,
                            _verticalCenterRange);
}

- (BOOL)playerIsVerticallyCenteredOnScreen
{
   return NSLocationInRange(_playerSprite.position.y + _playerSprite.boundingBox.size.height/2.0,
                            _horizontalCenterRange);
}

- (BOOL)playerIsCenteredOnScreen
{
   return ([self playerIsHorizontallyCenteredOnScreen] &&
           [self playerIsVerticallyCenteredOnScreen]);
}

- (BOOL)mazeShouldMoveForPlayerDirection:(CharacterDirection)direction
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
   CharacterDirection direction = _playerSprite.direction;
   
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
      {
         destination = _playerSprite.position;
         _playerSprite.shouldMove = NO;
         [self stopPlayer];
      }
   }
   return destination;
}

- (CGPoint)getXYForDirection:(CharacterDirection)direction
{
   float x, y;
   
   _playerSprite.direction = direction;
   
   if ( _playerSprite.velocity.x <= MAX_VELOCITY )
      _playerSprite.velocity = ccp(_playerSprite.velocity.x + 0.3,
                                         _playerSprite.velocity.y + 0.3);
   switch ( direction )
   {
      case e_NORTH:
         x = 0;
         y = _playerSprite.velocity.y;
         break;
      case e_EAST:
         x = _playerSprite.velocity.x;
         y = 0;
         break;
      case e_SOUTH:
         x = 0;
         y = -_playerSprite.velocity.y;
         break;
      case e_WEST:
         x = -_playerSprite.velocity.x;
         y = 0;
         break;
      default:
         break;
   }
   return ccp(x,y);
}

- (void)stopPlayer
{
   GameController *gameController = [GameController sharedController];
   [gameController.gameLayer.playerSprite clearMoveStack];
   _playerSprite.isMoving = NO;
   _playerSprite.direction = e_NONE;
}

- (void)updatePlayerPostionForTile:(Tile *)nextTile
                        atLocation:(CGPoint)nextTileLocation
{
   GameController *gameController = [GameController sharedController];
   if ( _playerSprite.shouldMove == NO )
   {
      if (_moveMaze)
      {
         int xMazeOffset = _playerSprite.position.x - nextTileLocation.x;
         int yMazeOffset = _playerSprite.position.y - nextTileLocation.y;
         _mazeLayer.position = ccp(_mazeLayer.position.x + xMazeOffset,
                                   _mazeLayer.position.y + yMazeOffset);
      }
      else
      {
         _playerSprite.position = nextTileLocation;
      }
      [self stopPlayer];
   }

   gameController.level.maze.tileWithPlayer = nextTile;
   
   if (![gameController.gameLayer.playerSprite moveStackIsEmpty])
   {
      CharacterDirection nextDirection = [gameController.gameLayer.playerSprite topMoveStack];
      if ([nextTile getAdjacentEdgeForDirection:nextDirection].walkable)
      {
         _playerSprite.direction = [gameController.gameLayer.playerSprite popMoveStack];
         _playerSprite.position = nextTileLocation;
      }
   }
}

- (void)updateCurrentTileWithPlayer
{
   GameController *gameController = [GameController sharedController];
   Tile *currentTile = gameController.level.maze.tileWithPlayer;
   Tile *nextTile = [currentTile getAdjacentTileForDirection:_playerSprite.direction];
   
   // tile sprite positions don't update when the maze layer is moved, so we need to offset the
   // original position of the tile sprite by the position of the maze layer
   CGPoint nextTileLocation = CGPointMake(nextTile.tileSprite.position.x + _mazeLayer.position.x + _xPlayerOffset,
                                          nextTile.tileSprite.position.y + _mazeLayer.position.y + _yPlayerOffset);
   if (nextTile == nil)
   {
      _playerSprite.shouldMove = NO;
      [self stopPlayer];
   }
   else
   {
      switch (_playerSprite.direction)
      {
         case e_NORTH:
            if (_playerSprite.position.y >= nextTileLocation.y)
               [self updatePlayerPostionForTile:nextTile
                                     atLocation:nextTileLocation];
            break;
         case e_EAST:
            if (_playerSprite.position.x >= nextTileLocation.x)
               [self updatePlayerPostionForTile:nextTile
                                     atLocation:nextTileLocation];
            break;
         case e_SOUTH:
            if (_playerSprite.position.y <= nextTileLocation.y)
               [self updatePlayerPostionForTile:nextTile
                                     atLocation:nextTileLocation];
            break;
         case e_WEST:
            if (_playerSprite.position.x <= nextTileLocation.x)
               [self updatePlayerPostionForTile:nextTile
                                     atLocation:nextTileLocation];
            break;
         default:
            break;
      }
   }
}

- (BOOL)direction:(CharacterDirection)direction
isOppositeToDirection:(CharacterDirection)otherDirection
{
   switch (direction)
   {
      case e_NORTH:
         return (otherDirection == e_SOUTH);
      case e_SOUTH:
         return (otherDirection == e_NORTH);
      case e_EAST:
         return (otherDirection == e_WEST);
      case e_WEST:
         return (otherDirection == e_EAST);
      case e_NONE:
      default:
         return NO;
   }
}

- (void)moveCharacter:(MMCharacter *)character
{
   GameController *gameController = [GameController sharedController];
   CGPoint destination;
   
   if ([gameController canMoveFromTile:character.currentTile
                           inDirection:character.direction] == NO)
   {
      character.shouldMove = NO;
      //[self stopPlayer];
      
      // TODO: put these in their own function
      character.isMoving = NO;
      character.direction = e_NONE;
      return;
   }
   
   if (character.isMoving)
   {
      // TODO: enemy moveStack
      if ([self direction:[gameController.gameLayer.playerSprite topMoveStack]
                        isOppositeToDirection:_playerSprite.direction])
      {
         Tile *currentTile = gameController.level.maze.tileWithPlayer;
         gameController.level.maze.tileWithPlayer =
            [currentTile getAdjacentTileForDirection:_playerSprite.direction];
         _playerSprite.direction = [gameController.gameLayer.playerSprite popMoveStack];
      }

      CGPoint directionPoint = [self getXYForDirection:_playerSprite.direction];
      destination = [self getDestinationPointForX:directionPoint.x
                                                y:directionPoint.y];
      
      // _moveMaze is on when the maze moves instead of the player
      float diffX, diffY;
      if (_moveMaze)
      {
         diffX = _mazeLayer.position.x - destination.x;
         diffY = _mazeLayer.position.y - destination.y;
      }
      else
      {
         diffX = destination.x - _playerSprite.position.x;
         diffY = destination.y - _playerSprite.position.y;
      }
      
      CCNode *moveableObject = (_moveMaze)? _mazeLayer : _playerSprite;
      moveableObject.position = destination;
      
      _playerSprite.absolutePosition = ccp(_playerSprite.absolutePosition.x + diffX,
                                           _playerSprite.absolutePosition.y + diffY);
      [self updateCurrentTileWithPlayer];
   }
   
}

- (void)movePlayer
{
   GameController *gameController = [GameController sharedController];
   CGPoint destination;
   
   if ([gameController canMoveFromTile:gameController.level.maze.tileWithPlayer
                           inDirection:gameController.gameLayer.playerSprite.direction] == NO)
   {
      _playerSprite.shouldMove = NO;
      [self stopPlayer];
      return;
   }
   
   if (_playerSprite.isMoving)
   {
      if ([self direction:[gameController.gameLayer.playerSprite topMoveStack]
                        isOppositeToDirection:_playerSprite.direction])
      {
         Tile *currentTile = gameController.level.maze.tileWithPlayer;
         gameController.level.maze.tileWithPlayer =
            [currentTile getAdjacentTileForDirection:_playerSprite.direction];
         _playerSprite.direction = [gameController.gameLayer.playerSprite popMoveStack];
      }

      CGPoint directionPoint = [self getXYForDirection:_playerSprite.direction];
      destination = [self getDestinationPointForX:directionPoint.x
                                                y:directionPoint.y];
      
      // _moveMaze is on when the maze moves instead of the player
      float diffX, diffY;
      if (_moveMaze)
      {
         diffX = _mazeLayer.position.x - destination.x;
         diffY = _mazeLayer.position.y - destination.y;
      }
      else
      {
         diffX = destination.x - _playerSprite.position.x;
         diffY = destination.y - _playerSprite.position.y;
      }
      
      CCNode *moveableObject = (_moveMaze)? _mazeLayer : _playerSprite;
      moveableObject.position = destination;
      
      _playerSprite.absolutePosition = ccp(_playerSprite.absolutePosition.x + diffX,
                                           _playerSprite.absolutePosition.y + diffY);
      [self updateCurrentTileWithPlayer];
   }
}

-(void) moveEnemies
{
   [[GameController sharedController].level moveEnemies];
}

- (Tile *)getTileAtScreenLocation:(CGPoint)screenLocation
{
   CGPoint realLocation = ccp(screenLocation.x - _mazeLayer.position.x,
                              screenLocation.y - _mazeLayer.position.y);
   return [[GameController sharedController].level.maze getTileAtLocation:realLocation
                                                              forTileSize:_tileSize];
}

// ControlsActionDelegate optional protocols
- (void)handleTapAtLocation:(CGPoint)location
{
//   Tile *tile = [self getTileAtScreenLocation:location];
}

- (void)handleDoubleTapAtLocation:(CGPoint)location
{
   Tile *tile = [self getTileAtScreenLocation:location];
   _opaque->pathFinder->getPathToTile(tile);
}

+ (CCScene *)scene
{
   GameController *gameController = [GameController sharedController];
   
   MazeLayer *mazeLayer = [[[MazeLayer alloc] initWithMaze:gameController.level.maze] autorelease];
   GameLayer *gameLayer = [[[GameLayer alloc] initWithMaze:mazeLayer] autorelease];
   ControlsLayer *controlsLayer = [ControlsLayer node];

   // this is so the game layer can respond to double tap events
   controlsLayer.delegate = gameLayer;

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
