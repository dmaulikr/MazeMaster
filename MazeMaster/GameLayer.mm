
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
#import "Maze.h"
#import "MazeLayer.h"
#import "Player.h"
#import "Tile.h"
#import "MMEnemy.h"

@interface GameLayer()
{
   CGSize _windowSize;
   CGSize _tileSize;

   int _outsideEdgePadding;

   NSRange _verticalCenterRange;
   NSRange _horizontalCenterRange;

   BOOL _moveMaze;
}
@end

@implementation GameLayer

#pragma mark -- Setup Methods --
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

- (void)setupPlayer
{
   _playerSprite = [Player playerWithFile:@"astronaut_front.png"];
   _playerSprite.anchorPoint = CGPointZero;
   _playerSprite.scale = 1.8;
   _playerSprite.maxVelocity = ccp(1.1, 1.1);

   float xPlayerOffset = (_tileSize.width/2.0) - (_playerSprite.boundingBox.size.width/2.0);
   float yPlayerOffset = (_tileSize.height/2.0) - (_playerSprite.boundingBox.size.height/2.0);
   _playerSprite.offset = ccp(xPlayerOffset,
                              yPlayerOffset);
   
   _playerSprite.position = _playerSprite.offset;
   _playerSprite.absolutePosition = _playerSprite.offset;

   _playerSprite.currentTile = [[GameController sharedController].level.maze
                                getTileAtLocation:_playerSprite.absolutePosition
                                      forTileSize:_tileSize];
   [self addChild:_playerSprite];
}

- (void)setupEnemies
{
   [[GameController sharedController].level addEnemiesToLayer:self];
   [[GameController sharedController].level setEnemyTargets:_playerSprite.currentTile];
   [[GameController sharedController].level setEnemyPositions];
}

- (void)setupMazeLayer:(MazeLayer *)mazeLayer
{
   _mazeLayer = mazeLayer;
   _mazeLayer.anchorPoint = CGPointZero;
   _moveMaze = NO;
}

#pragma mark -- Init Methods --
- (id)init
{
	if (self = [super init])
   {
      [self setupVariables];
      [self setupPlayer];
      [self setupEnemies];
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

#pragma mark -- Screen Helper Methods --
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

- (Tile *)getTileAtScreenLocation:(CGPoint)screenLocation
{
   CGPoint realLocation = ccp(screenLocation.x - _mazeLayer.position.x,
                              screenLocation.y - _mazeLayer.position.y);
   return [[GameController sharedController].level.maze getTileAtLocation:realLocation
                                                              forTileSize:_tileSize];
}

#pragma mark -- Maze Helper Methods --
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

- (BOOL)position:(CGPoint)position
inMazeBoundsForCharacter:(MMCharacter *)character
{
   float characterHeight = character.boundingBox.size.height;
   float characterWidth = character.boundingBox.size.width;
   
   // north
   if ([self yValuePastNorthMazeBound:(position.y + characterHeight)])
      return NO;
   // south
   if ([self yValuePastSouthMazeBound:position.y])
      return NO;
   // east
   if ([self xValuePastEastMazeBound:(position.x + characterWidth)])
      return NO;
   // west
   if ([self xValuePastWestMazeBound:position.x])
      return NO;

   return YES;
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

# pragma mark -- Movement Helper Methods --
- (void)offsetEnemiesWithDeltaPoint:(CGPoint)deltaPoint
{
   for (MMEnemy *enemy in [GameController sharedController].level.enemies)
   {
      enemy.position = ccp(enemy.position.x - deltaPoint.x,
                           enemy.position.y - deltaPoint.y);
   }
}

- (CGPoint)getDestinationPointForCharacter:(MMCharacter *)character
                                       atX:(float)x
                                         y:(float)y
{
   CGPoint destination;
   CharacterDirection direction = character.direction;
   
   if (character.isPlayer && [self mazeShouldMoveForPlayerDirection:direction])
   {
      _moveMaze = YES;
      destination = ccp(_mazeLayer.position.x - x,
                        _mazeLayer.position.y - y);
   }
   else
   {
      _moveMaze = NO;
      destination = ccp(character.position.x + x,
                        character.position.y + y);

      if (character.isPlayer && ![self position:destination
                       inMazeBoundsForCharacter:character])
      {
         destination = character.position;
         character.shouldMove = NO;
         [self stopCharacter:character];
      }
   }
   return destination;
}

- (CGPoint)getDirectionPointForCharacter:(MMCharacter *)character
{
   float x, y;
   if (character.velocity.x <= character.maxVelocity.x)
      character.velocity = ccp(character.velocity.x + 0.3,
                               character.velocity.y + 0.3);
   switch (character.direction)
   {
      case e_NORTH:
         x = 0;
         y = character.velocity.y;
         break;
      case e_EAST:
         x = character.velocity.x;
         y = 0;
         break;
      case e_SOUTH:
         x = 0;
         y = -character.velocity.y;
         break;
      case e_WEST:
         x = -character.velocity.x;
         y = 0;
         break;
      default:
         break;
   }
   return ccp(x,y);
}

- (void)setMazePositionForCharacter:(MMCharacter *)character
                 atNextTileLocation:(CGPoint)nextTileLocation
{
   int xMazeOffset = character.position.x - nextTileLocation.x;
   int yMazeOffset = character.position.y - nextTileLocation.y;
   _mazeLayer.position = ccp(_mazeLayer.position.x + xMazeOffset,
                             _mazeLayer.position.y + yMazeOffset);
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

#pragma mark -- Movement Methods --
- (void)stopCharacter:(MMCharacter *)character
{
   if (!character.isPlayer)
   {
      switch ([(MMEnemy *)character state])
      {
         case e_WANDERING:
            break;
         case e_CHASING:
            [(MMEnemy *)character setState:e_SLEEPING];
            break;
         default:
            break;
      }
   }

   [character clearMoveStack];
   character.isMoving = NO;
   character.direction = e_NONE;
}

- (void)stopEnemies
{
   for (MMEnemy *enemy in [GameController sharedController].level.enemies)
   {
      enemy.state = e_SLEEPING;
      [self stopCharacter:enemy];
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

      CGPoint directionPoint = [self getDirectionPointForCharacter:character];
      destination = [self getDestinationPointForCharacter:character
                                                      atX:directionPoint.x
                                                        y:directionPoint.y];
      float diffX, diffY;
      if (_moveMaze && character.isPlayer)
      {
         diffX = _mazeLayer.position.x - destination.x;
         diffY = _mazeLayer.position.y - destination.y;
         [self offsetEnemiesWithDeltaPoint:directionPoint];
      }
      else
      {
         diffX = destination.x - character.position.x;
         diffY = destination.y - character.position.y;
      }

      CCNode *moveableObject = (_moveMaze) ? _mazeLayer : character;
      moveableObject.position = destination;

      character.absolutePosition = ccp(character.absolutePosition.x + diffX,
                                       character.absolutePosition.y + diffY);

      [self updateCurrentTileWithCharacter:character];
   }
}

#pragma mark -- Action Methods --
- (void)makeEnemiesChasePlayer
{
   for (MMEnemy *enemy in [GameController sharedController].level.enemies)
   {
      enemy.state = e_CHASING;
      enemy.target = _playerSprite.currentTile;
      enemy.shouldCalculateNewPath = YES;
   }
}

- (void)makeEnemiesWander
{
   for (MMEnemy *enemy in [GameController sharedController].level.enemies)
   {
      enemy.state = e_WANDERING;
      enemy.target = [[GameController sharedController].level.maze getRandomTile];
      enemy.shouldCalculateNewPath = YES;
   }
}

#pragma mark -- Update Methods --
- (void)update:(ccTime)delta
{
   [self moveCharacter:_playerSprite];
   for (MMEnemy *enemy in [GameController sharedController].level.enemies)
      [self moveCharacter:enemy];
}

- (void)updateCharacterPostion:(MMCharacter *)character
                       forTile:(Tile *)nextTile
                    atLocation:(CGPoint)nextTileLocation
{
   // since this is where the start of a new tile is happening, the enemy should repath to where
   // the player currently is
   if (!character.isPlayer)
   {
      EnemyState state = [(MMEnemy *)character state];
      switch (state)
      {
         case e_CHASING:
            if (character.shouldMove)
               [(MMEnemy *)character setShouldCalculateNewPath:YES];
            break;

         case e_WANDERING:
            if (character.shouldMove && [character moveStackIsEmpty])
               [(MMEnemy *)character setShouldCalculateNewPath:YES];
         default:
            break;
      }
   }
   if (character.shouldMove == NO)
   {
      if (_moveMaze)
         [self setMazePositionForCharacter:character
                        atNextTileLocation:nextTileLocation];
      else
         character.position = nextTileLocation;

      [self stopCharacter:character];
   }
   
   character.currentTile = nextTile;

   if (![character moveStackIsEmpty])
   {
      CharacterDirection nextDirection = [character topMoveStack];
      if ([nextTile getAdjacentEdgeForDirection:nextDirection].walkable)
         character.direction = [character popMoveStack];
   }
   else if (!character.isPlayer && [character moveStackIsEmpty])
   {
      [self stopCharacter:character];
   }
}

- (void)updateCurrentTileWithCharacter:(MMCharacter *)character
{
   Tile *currentTile = character.currentTile;
   Tile *nextTile = [currentTile getAdjacentTileForDirection:character.direction];

   if (!character.isPlayer)
      nextTile.isActive = YES;

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

#pragma mark -- Controls Action Delegate Protocols --
- (void)handleTapAtLocation:(CGPoint)location
{
   Tile *tile = [self getTileAtScreenLocation:location];
   NSLog(@"single tap at tile: %@, active: %d", NSStringFromCGPoint(tile.position), tile.isActive);
}

- (void)handleDoubleTapAtLocation:(CGPoint)location
{
//   [self makeEnemiesChasePlayer];
   [self makeEnemiesWander];
}

#pragma mark -- Scene Method --
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
