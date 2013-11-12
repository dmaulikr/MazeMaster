//
//  MMCharacter.m
//  MazeMaster
//
//  Created by Fila, Justin on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "MMCharacter.h"
#import "Tile.h"

#include "PathFinder.h"
#include "GameController.h"
#include "GameLayer.h"

@interface MMCharacter()
{
   NSMutableArray *_moveStack;
   PathFinder *_pathFinder;
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
      _pathFinder = new PathFinder(travelerKey);
   }
   return self;
}

- (void)setupPathFinderWithTravelerKey:(NSString *)travelerKey
{
   _travelerKey = travelerKey;
   _pathFinder = new PathFinder(travelerKey);
}

- (void)setTileGenerationOrder:(TileGenerationOrder)tileGenerationOrder
{
   _tileGenerationOrder = tileGenerationOrder;
   _pathFinder->setTileGenerationOrder(_tileGenerationOrder);
}

- (void)setCurrentTile:(Tile *)currentTile
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
   }
   return nil;
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

- (BOOL)calculatePathToTile:(Tile *)tile
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

- (void)updatePositionForTile:(Tile *)nextTile
                   atLocation:(CGPoint)nextTileLocation
              andMazeMovement:(BOOL)mazeMoving
{
   [self evaluateStateAndPotentiallyCalculatePathInTheFuture];

   if (self.shouldMove == NO)
   {
      if (mazeMoving)
         [[GameController sharedController].gameLayer setMazePositionForCharacter:self
                     atNextTileLocation:nextTileLocation];
      else
         self.position = nextTileLocation;

      [self stopMoving];
   }

   self.currentTile = nextTile;

   if (![self moveStackIsEmpty])
   {
      CharacterDirection nextDirection = [self topMoveStack];
      if ([nextTile getAdjacentEdgeForDirection:nextDirection].walkable)
         self.direction = [self popMoveStack];
   }
}

-(void)evaluateStateAndPotentiallyCalculatePathInTheFuture
{
   return;
}

- (void)updateCurrentTileForMazeMovement:(BOOL)mazeMoving
{
   Tile *nextTile = [_currentTile getAdjacentTileForDirection:_direction];

   // TODO: add to beginning of enemy
//   if (!character.isPlayer)
//      nextTile.isActive = YES;

   // tile sprite positions don't update when the maze layer is moved, so we need to offset the
   // original position of the tile sprite by the position of the maze layer
   CGPoint nextTileLocation = ccp(nextTile.tileSprite.position.x + _offset.x,
                                  nextTile.tileSprite.position.y + _offset.y);
   if (nextTile == nil)
   {
      _shouldMove = NO;
      [self stopMoving];
   }
   else
   {
      switch (_direction)
      {
         case e_NORTH:
            if (_position.y >= nextTileLocation.y)
               [self updatePositionForTile:nextTile
                                     atLocation:nextTileLocation
                                andMazeMovement:mazeMoving];
            break;
         case e_EAST:
            if (_position.x >= nextTileLocation.x)
               [self updatePositionForTile:nextTile
                                atLocation:nextTileLocation
                           andMazeMovement:mazeMoving];
            break;
         case e_SOUTH:
            if (_position.y <= nextTileLocation.y)
               [self updatePositionForTile:nextTile
                                atLocation:nextTileLocation
                           andMazeMovement:mazeMoving];
            break;
         case e_WEST:
            if (_position.x <= nextTileLocation.x)
               [self updatePositionForTile:nextTile
                                atLocation:nextTileLocation
                           andMazeMovement:mazeMoving];
            break;
         default:
            break;
      }
   }
}

@end
