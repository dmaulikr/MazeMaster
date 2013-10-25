
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
#import "Tile.h"
#import "Player.h"

#include "PathFinder.h"

@interface GameLayer()
{
   PathFinder *_pathFinder;
}

@end

@implementation GameLayer

#define MAX_VELOCITY 1.7

- (void)onEnter
{
   [super onEnter];
   NSLog(@"On Enter");
}

- (void)onEnterTransitionDidFinish
{
   [super onEnterTransitionDidFinish];
   NSLog(@"");
}

- (void)setupVariables
{
   _windowSize = [[CCDirector sharedDirector] winSize];
   _tileSize = CGSizeMake(44, 44);
   _outsideEdgePadding = 0;
   _verticalCenterRange = NSMakeRange(_windowSize.width/2.0 - _tileSize.width/4.0,
                                      _tileSize.width/2.0);
   _horizontalCenterRange = NSMakeRange(_windowSize.height/2.0 - _tileSize.height/4.0,
                                      _tileSize.height/2.0);
   
   _pathFinder = new PathFinder();
}

- (void)setupPlayer
{
   _playerSprite = [Player playerWithFile:@"astronaut_front.png"];
   _playerSprite.anchorPoint = CGPointZero;
   _playerSprite.scale = 1.8;

   float xPlayerOffset = (_tileSize.width/2.0) - (_playerSprite.boundingBox.size.width/2.0);
   float yPlayerOffset = (_tileSize.height/2.0) - (_playerSprite.boundingBox.size.height/2.0);
   _playerSprite.offset = ccp(xPlayerOffset, yPlayerOffset);
   
   _playerSprite.position = _playerSprite.offset;
   _playerSprite.absolutePosition = _playerSprite.offset;

   [self updateTileContainingCharacter:_playerSprite
                           forTileSize:_tileSize];
   [self addChild:_playerSprite];
}

- (void)updateTileContainingCharacter:(MMCharacter *)character
                          forTileSize:(CGSize)tileSize
{
   int xTile = (character.absolutePosition.x / tileSize.width) + 1;
   int yTile = (character.absolutePosition.y / tileSize.height) + 1;

   character.currentTile = [[GameController sharedController].level.maze
                                          tileAtPosition:CGPointMake(xTile, yTile)];
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
   delete _pathFinder;
   [super dealloc];
}

- (void)update:(ccTime)delta
{
//   [self movePlayer];
   [self moveCharacter:_playerSprite];
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
         [self stopCharacter:_playerSprite];
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

- (void)stopCharacter:(MMCharacter *)character
{
   [character clearMoveStack];
   character.isMoving = NO;
   character.direction = e_NONE;
}

- (void)updateCharacterPostion:(MMCharacter *)character
                       forTile:(Tile *)nextTile
                    atLocation:(CGPoint)nextTileLocation
{
   if ( character.shouldMove == NO )
   {
      if (_moveMaze && [character isKindOfClass:[Player class]])
      {
         int xMazeOffset = character.position.x - nextTileLocation.x;
         int yMazeOffset = character.position.y - nextTileLocation.y;
         _mazeLayer.position = ccp(_mazeLayer.position.x + xMazeOffset,
                                   _mazeLayer.position.y + yMazeOffset);
      }
      else
      {
         character.position = nextTileLocation;
      }
      [self stopCharacter:character];
   }

   character.currentTile = nextTile;
   
   if (![character moveStackIsEmpty])
   {
      CharacterDirection nextDirection = [character topMoveStack];
      if ([nextTile getAdjacentEdgeForDirection:nextDirection].walkable)
      {
         character.direction = [character popMoveStack];
         character.position = nextTileLocation;
      }
   }
}

- (void)updateCurrentTileWithCharacter:(MMCharacter *)character
{
//   GameController *gameController = [GameController sharedController];
   Tile *currentTile = character.currentTile;
   Tile *nextTile = [currentTile getAdjacentTileForDirection:character.direction];
   
   // tile sprite positions don't update when the maze layer is moved, so we need to offset the
   // original position of the tile sprite by the position of the maze layer
   CGPoint nextTileLocation = ccp(nextTile.tileSprite.position.x + _mazeLayer.position.x + character.offset.x,
                                  nextTile.tileSprite.position.y + _mazeLayer.position.y + character.offset.y);
   if (nextTile == nil)
   {
      character.shouldMove = NO;
      [self stopCharacter:character];
   }
   else
   {
      switch (character.direction)
      {
         case e_NORTH:
            if (character.position.y >= nextTileLocation.y)
               [self updateCharacterPostion:character
                                    forTile:nextTile
                                 atLocation:nextTileLocation];
            break;
         case e_EAST:
            if (character.position.x >= nextTileLocation.x)
               [self updateCharacterPostion:character
                                    forTile:nextTile
                                 atLocation:nextTileLocation];
            break;
         case e_SOUTH:
            if (character.position.y <= nextTileLocation.y)
               [self updateCharacterPostion:character
                                    forTile:nextTile
                                 atLocation:nextTileLocation];
            break;
         case e_WEST:
            if (character.position.x <= nextTileLocation.x)
               [self updateCharacterPostion:character
                                    forTile:nextTile
                                 atLocation:nextTileLocation];
            break;
         default:
            break;
      }
   }
}

//- (void)updateCurrentTileWithPlayer
//{
//   Tile *currentTile = _playerSprite.currentTile;
//   Tile *nextTile = [currentTile getAdjacentTileForDirection:_playerSprite.direction];
//   
//   // tile sprite positions don't update when the maze layer is moved, so we need to offset the
//   // original position of the tile sprite by the position of the maze layer
//   CGPoint nextTileLocation = CGPointMake(nextTile.tileSprite.position.x + _mazeLayer.position.x + _xPlayerOffset,
//                                          nextTile.tileSprite.position.y + _mazeLayer.position.y + _yPlayerOffset);
//   if (nextTile == nil)
//   {
//      _playerSprite.shouldMove = NO;
//      [self stopCharacter:_playerSprite];
//   }
//   else
//   {
//      switch (_playerSprite.direction)
//      {
//         case e_NORTH:
//            if (_playerSprite.position.y >= nextTileLocation.y)
//               [self updatePlayerPostionForTile:nextTile
//                                     atLocation:nextTileLocation];
//            break;
//         case e_EAST:
//            if (_playerSprite.position.x >= nextTileLocation.x)
//               [self updatePlayerPostionForTile:nextTile
//                                     atLocation:nextTileLocation];
//            break;
//         case e_SOUTH:
//            if (_playerSprite.position.y <= nextTileLocation.y)
//               [self updatePlayerPostionForTile:nextTile
//                                     atLocation:nextTileLocation];
//            break;
//         case e_WEST:
//            if (_playerSprite.position.x <= nextTileLocation.x)
//               [self updatePlayerPostionForTile:nextTile
//                                     atLocation:nextTileLocation];
//            break;
//         default:
//            break;
//      }
//   }
//}

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
   
   if ([gameController character:character
                 canMoveFromTile:character.currentTile] == NO)
   {
      character.shouldMove = NO;
      [self stopCharacter:character];
      
      // TODO: put these in their own function
      character.isMoving = NO;
      character.direction = e_NONE;
      return;
   }
   
   if (character.isMoving)
   {
      if ([self direction:[character topMoveStack] isOppositeToDirection:character.direction])
      {
         Tile *currentTile = character.currentTile;
         character.currentTile = [currentTile getAdjacentTileForDirection:character.direction];
         character.direction = [character popMoveStack];
      }

      CGPoint directionPoint = [self getXYForDirection:character.direction];
      destination = [self getDestinationPointForX:directionPoint.x
                                                y:directionPoint.y];
      
      // _moveMaze is on when the maze moves instead of the player
      float diffX, diffY;
      if (_moveMaze && [character isKindOfClass:[Player class]])
      {
         diffX = _mazeLayer.position.x - destination.x;
         diffY = _mazeLayer.position.y - destination.y;
      }
      else
      {
         diffX = destination.x - character.position.x;
         diffY = destination.y - character.position.y;
      }
      
      CCNode *moveableObject = (_moveMaze)? _mazeLayer : character;
      moveableObject.position = destination;
      
      character.absolutePosition = ccp(character.absolutePosition.x + diffX,
                                       character.absolutePosition.y + diffY);
      
      [self updateCurrentTileWithCharacter:character];
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
   Tile *tile = [self getTileAtScreenLocation:location];
   NSLog(@"single tap at tile: %@", NSStringFromCGPoint(tile.position));
}

- (void)testAStarWithDirectionsArray:(CCArray *)directions
{
   CharacterDirection direction = e_NONE;
   for (NSNumber *directionNumber in directions)
   {
      direction = (CharacterDirection)directionNumber.intValue;
      [_playerSprite pushMoveStack:direction];
   }

   _playerSprite.direction = [_playerSprite popMoveStack];
   _playerSprite.isMoving = YES;
   _playerSprite.shouldMove = YES;
}

- (void)handleDoubleTapAtLocation:(CGPoint)location
{
   Tile *start = _playerSprite.currentTile;
   Tile *goal = [self getTileAtScreenLocation:location];
   
   CCArray *directions = _pathFinder->calculatePath(start, goal);
   [self testAStarWithDirectionsArray:directions];
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
