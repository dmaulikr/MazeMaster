
//
//  MMGameLayer.m
//  MazeMaster
//
//  Created by Gregory Klein on 8/6/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "MMGameLayer.h"

#import "MMGameController.h"
#import "MMLevel.h"
#import "MMLevelSelectLayer.h"
#import "MMMaze.h"
#import "MMMazeLayer.h"
#import "MMPlayer.h"
#import "MMTile.h"
#import "MMEnemy.h"
#import "MMVictim.h"

@interface MMGameLayer()
{
   CGSize _windowSize;
   CGSize _tileSize;

   int _outsideEdgePadding;

   NSRange _verticalCenterRange;
   NSRange _horizontalCenterRange;

   BOOL _moveMaze;
}
@end

@implementation MMGameLayer

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
   _playerSprite = [MMPlayer playerWithFile:@"astronaut_front.png"];
   _playerSprite.anchorPoint = CGPointZero;
   _playerSprite.scale = 1.8;
   _playerSprite.maxVelocity = ccp(1.1, 1.1);

   float xPlayerOffset = (_tileSize.width/2.0) - (_playerSprite.boundingBox.size.width/2.0);
   float yPlayerOffset = (_tileSize.height/2.0) - (_playerSprite.boundingBox.size.height/2.0);
   _playerSprite.offset = ccp(xPlayerOffset,
                              yPlayerOffset);
   
   _playerSprite.position = _playerSprite.offset;

   _playerSprite.currentTile = [[MMGameController sharedController].level.maze
                                getTileAtLocation:_playerSprite.position
                                      forTileSize:_tileSize];
}

- (void)setupEnemies
{
   [[MMGameController sharedController].level setEnemyTargets:_playerSprite.currentTile];
   [[MMGameController sharedController].level setEnemyPositions];
}

- (void)setupVictims
{
   [[MMGameController sharedController].level setVictimPositions];
}

- (void)setupMazeLayer:(MMMazeLayer *)mazeLayer
{
   _mazeLayer = mazeLayer;
   _mazeLayer.anchorPoint = CGPointZero;
   _moveMaze = NO;
   [[MMGameController sharedController].level addVictimsToLayer:mazeLayer];
   [[MMGameController sharedController].level addEnemiesToLayer:mazeLayer];
   [mazeLayer addChild:_playerSprite];
   
}

#pragma mark -- Init Methods --
- (id)init
{
	if (self = [super init])
   {
      [self setupVariables];
      [self setupPlayer];
      [self setupEnemies];
      [self setupVictims];
      [self scheduleUpdate];
	}
	return self;
}

- (id)initWithMaze:(MMMazeLayer *)mazeLayer
{
   if (self = [self init])
      [self setupMazeLayer:mazeLayer];

   return self;
}

#pragma mark -- Screen Helper Methods --
- (BOOL)playerIsHorizontallyCenteredOnScreen
{
   return NSLocationInRange(_playerSprite.position.x + _mazeLayer.position.x,
                            _verticalCenterRange);
}

- (BOOL)playerIsVerticallyCenteredOnScreen
{
   return NSLocationInRange(_playerSprite.position.y + _mazeLayer.position.y,
                            _horizontalCenterRange);
}

- (MMTile *)getTileAtScreenLocation:(CGPoint)screenLocation
{
   CGPoint realLocation = ccp(screenLocation.x - _mazeLayer.position.x,
                              screenLocation.y - _mazeLayer.position.y);
   return [[MMGameController sharedController].level.maze getTileAtLocation:realLocation
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
- (CGPoint)getDestinationPointForCharacter:(MMCharacter *)character
                                       atX:(float)x
                                         y:(float)y
{
   CGPoint destination = ccp(character.position.x + x,
                             character.position.y + y);

   CharacterDirection direction = character.direction;
   
   if (character.isPlayer && [self mazeShouldMoveForPlayerDirection:direction])
      _moveMaze = YES;
   else
      _moveMaze = NO;
   
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
- (void)stopEnemies
{
   for (MMEnemy *enemy in [MMGameController sharedController].level.enemies)
   {
      enemy.state = e_SLEEPING;
      [enemy stopMoving];
   }
}

- (void)moveCharacter:(MMCharacter *)character
{
   MMGameController *gameController = [MMGameController sharedController];
   CGPoint destination;

   if ([gameController character:character
                 canMoveFromTile:character.currentTile] == NO)
   {
      if ([character stopMoving])
      {
         character.shouldMove = NO;
         return;
      }
   }

   if (character.isMoving)
   {
      //TODO-MM: comment this out for moving in opposite dir
//      if ([self direction:[character topMoveStack] isOppositeToDirection:character.direction])
//      {
//         // TODO: special case for victim following
//         MMTile *currentTile = character.currentTile;
//         character.currentTile = [currentTile getAdjacentTileForDirection:character.direction];
//         character.direction = [character popMoveStack];
//         
//      }

      CGPoint directionPoint = [self getDirectionPointForCharacter:character];

      destination = [self getDestinationPointForCharacter:character
                                                      atX:directionPoint.x
                                                        y:directionPoint.y];
      character.position = destination;
      _mazeLayer.position = (_moveMaze) ? ccp(_mazeLayer.position.x - directionPoint.x,
                                              _mazeLayer.position.y - directionPoint.y) :
                                              _mazeLayer.position;

      [character updateCurrentTileForMazeMovement:_moveMaze];
   }
   
   if ([character parentStoppedMoving])
   {
      character.shouldMove = NO;
      [character stopMoving];
   }
}

#pragma mark -- Action Methods --
- (void)makeEnemiesChasePlayer
{
   for (MMEnemy *enemy in [MMGameController sharedController].level.enemies)
   {
      enemy.state = e_CHASING;
      enemy.target = _playerSprite.currentTile;
      enemy.shouldCalculateNewPath = YES;
   }
}

- (void)makeEnemiesWander
{
   for (MMEnemy *enemy in [MMGameController sharedController].level.enemies)
   {
      enemy.state = e_WANDERING;
      enemy.target = [[MMGameController sharedController].level.maze getRandomTile];
      enemy.shouldCalculateNewPath = YES;
   }
}

#pragma mark -- Update Methods --
- (void)update:(ccTime)delta
{
   [self moveCharacter:_playerSprite];
   for (MMEnemy *enemy in [MMGameController sharedController].level.enemies)
   {
      [enemy examineAwarenessProximityForCharacter:_playerSprite];
      [self moveCharacter:enemy];
      
      if ( !CGRectIsNull(CGRectIntersection(_playerSprite.boundingBox, enemy.boundingBox)) )
          [enemy stopMoving];
   }
   
   [self moveCharacter:_playerSprite.victim];
}

#pragma mark -- Controls Action Delegate Protocols --
- (void)handleTapAtLocation:(CGPoint)location
{
   MMTile *tile = [self getTileAtScreenLocation:location];
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
   MMGameController *gameController = [MMGameController sharedController];
   
   MMMazeLayer *mazeLayer = [[[MMMazeLayer alloc] initWithMaze:gameController.level.maze] autorelease];
   MMGameLayer *gameLayer = [[[MMGameLayer alloc] initWithMaze:mazeLayer] autorelease];
   MMControlsLayer *controlsLayer = [MMControlsLayer node];

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
