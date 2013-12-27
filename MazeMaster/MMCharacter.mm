//
//  MMCharacter.m
//  MazeMaster
//
//  Created by Fila, Justin on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "MMCharacter.h"
#import "MMPlayer.h"
#import "MMTile.h"

#include "MMPathFinder.h"
#include "MMGameController.h"
#include "MMGameLayer.h"

@interface MMCharacter()
{
   NSMutableArray *_moveStack;
   MMPathFinder *_pathFinder;
}
@end

@implementation MMCharacter

-(id) initWithFile:(NSString *)filename
{
   if (self = [super initWithFile:filename])
   {
      _velocity = CGPointZero;
      _direction = e_NONE;
      _tileGenerationOrder = e_CLOCKWISE;
      _moveStack = [NSMutableArray new];
   }
   return self;
}

- (id)initWithFile:(NSString *)filename
       travelerKey:(NSString *)travelerKey
{
   if (self = [self initWithFile:filename])
   {
      _travelerKey = travelerKey;
      _pathFinder = new MMPathFinder(travelerKey);
   }
   return self;
}

- (void)setupPathFinderWithTravelerKey:(NSString *)travelerKey
{
   _travelerKey = travelerKey;
   _pathFinder = new MMPathFinder(travelerKey);
}

- (void)setTileGenerationOrder:(TileGenerationOrder)tileGenerationOrder
{
   _tileGenerationOrder = tileGenerationOrder;
   _pathFinder->setTileGenerationOrder(_tileGenerationOrder);
}

- (void)setCurrentTile:(MMTile *)currentTile
{
   if (!_isPlayer)
      _currentTile.isActive = NO;

   _currentTile = currentTile;

   if (!_isPlayer)
      _currentTile.isActive = YES;
}

-(void) attack
{
   NSLog(@"Character attack");
}

- (BOOL)stopMoving
{
   [self clearMoveStack];
   self.isMoving = NO;
   self.direction = e_NONE;
   return YES;
}

- (BOOL)parentStoppedMoving
{
   return NO;
}

+(MMCharacter *) characterWithFile:(NSString *)filename;
{
   return [[[self alloc] initWithFile:filename] autorelease];
}

- (void)dealloc
{
   [_moveStack release];
   delete _pathFinder;
   [super dealloc];
}

-(void) pushMoveStack:(CharacterDirection)direction
{
   [_moveStack insertObject:[NSNumber numberWithInt:direction]
                    atIndex:0];
}

-(CharacterDirection) popMoveStack
{
   CharacterDirection direction = e_NONE;
   if (_moveStack.count)
   {
      NSNumber *directionNumber = [_moveStack lastObject];
      direction = (CharacterDirection)directionNumber.intValue;
      [_moveStack removeLastObject];
   }
   return direction;
}

-(CharacterDirection) topMoveStack
{
   CharacterDirection direction = e_NONE;
   if (_moveStack.count)
   {
      NSNumber *directionNumber = [_moveStack lastObject];
      direction = (CharacterDirection)directionNumber.intValue;
   }
   return direction;
}

-(void) clearMoveStack
{
   [_moveStack removeAllObjects];
}

-(BOOL) moveStackIsEmpty
{
   return !_moveStack.count;
}

- (BOOL) moveFromMoveStackTo:(NSMutableArray *)stack
{
   CharacterDirection direction = e_NONE;
   if (_moveStack.count)
   {
      NSNumber *directionNumber = [_moveStack lastObject];
      direction = (CharacterDirection)directionNumber.intValue;
      
      [stack addObject:[NSNumber numberWithInt:direction]];
      [_moveStack removeLastObject];
      return YES;
   }
   return NO;
}

- (CGPoint)getDirectionPoint
{
   float x, y;
   if (_velocity.x <= _maxVelocity.x)
      _velocity = ccp(_velocity.x + 0.3,
                      _velocity.y + 0.3);

   switch (_direction)
   {
      case e_NORTH:
         x = 0;
         y = _velocity.y;
         break;
      case e_EAST:
         x = _velocity.x;
         y = 0;
         break;
      case e_SOUTH:
         x = 0;
         y = -_velocity.y;
         break;
      case e_WEST:
         x = -_velocity.x;
         y = 0;
         break;
      default:
         break;
   }
   return ccp(x,y);
}

- (void)updatePositionWithCurrentDirection
{
   CGPoint directionPoint = [self getDirectionPoint];
   _position = ccp(_position.x + directionPoint.x,
                   _position.y + directionPoint.y);
}

- (NSString *)stringForDirection:(CharacterDirection)direction
{
   switch (direction)
   {
      case e_NORTH:
         return @"North";
      case e_EAST:
         return @"East";
      case e_SOUTH:
         return @"South";
      case e_WEST:
         return @"West";
      case e_NONE:
         return nil;
      default:
         return nil;
   }
}

- (void)addDirectionsToStack:(CCArray *)directions
{
   CharacterDirection direction;
   for (NSNumber *directionNumber in directions)
   {
      direction = (CharacterDirection)directionNumber.intValue;
      [self pushMoveStack:direction];
   }
}

- (BOOL)calculatePathToTile:(MMTile *)tile
{
   CCArray *directions = _pathFinder->calculatePath(_currentTile, tile);
   if (directions)
   {
      [self clearMoveStack];
      [self addDirectionsToStack:directions];
      return YES;
   }
   return NO;
}

- (void)beginExecutingCurrentPath
{
   _direction = [self popMoveStack];
   _isMoving = YES;
   _shouldMove = YES;
}

// called every time a character reaches a tile
- (void)updatePositionForTile:(MMTile *)nextTile
                   atLocation:(CGPoint)nextTileLocation
                 mazeMovement:(BOOL)mazeMoving
{
   [self evaluateStateAndPotentiallyCalculatePathInTheFuture];

   if (self.shouldMove == NO)
   {
      if (mazeMoving)
         [[MMGameController sharedController].gameLayer setMazePositionForCharacter:self
                     atNextTileLocation:nextTileLocation];
      else
         self.position = nextTileLocation;

      [self stopMoving];
   }

   self.currentTile = nextTile;
   [self updateCurrentDirection];
}

- (void) updateCurrentDirection
{
   // pop the move stack if the next tile is walkable
   if (![self moveStackIsEmpty])
   {
      CharacterDirection nextDirection = [self topMoveStack];
      if ([self.currentTile getAdjacentEdgeForDirection:nextDirection].walkable)
         self.direction = [self popMoveStack];
   }
}

-(void)evaluateStateAndPotentiallyCalculatePathInTheFuture
{
   return;
}

- (void)updateCurrentTileForMazeMovement:(BOOL)mazeMoving
{
   MMTile *nextTile = [_currentTile getAdjacentTileForDirection:_direction];
   
   // tile sprite positions don't update when the maze layer is moved, so we need to offset the
   // original position of the tile sprite by the position of the maze layer
   CGPoint nextTileLocation = ccp(nextTile.tileSprite.position.x + _offset.x,
                                  nextTile.tileSprite.position.y + _offset.y);
   if (nextTile == nil)
   {
      if ([self stopMoving])
         _shouldMove = NO;
   }
   else
   {
      switch (_direction)
      {
         case e_NORTH:
            if (_position.y >= nextTileLocation.y)
               [self updatePositionForTile:nextTile
                                atLocation:nextTileLocation
                                 mazeMovement:mazeMoving];
            break;
         case e_EAST:
            if (_position.x >= nextTileLocation.x)
               [self updatePositionForTile:nextTile
                                atLocation:nextTileLocation
                              mazeMovement:mazeMoving];
            break;
         case e_SOUTH:
            if (_position.y <= nextTileLocation.y)
               [self updatePositionForTile:nextTile
                                atLocation:nextTileLocation
                              mazeMovement:mazeMoving];
            break;
         case e_WEST:
            if (_position.x <= nextTileLocation.x)
               [self updatePositionForTile:nextTile
                                atLocation:nextTileLocation
                              mazeMovement:mazeMoving];
            break;
         default:
            break;
      }
   }
}

@end
