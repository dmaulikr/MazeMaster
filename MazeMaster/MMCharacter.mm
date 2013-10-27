//
//  MMCharacter.m
//  MazeMaster
//
//  Created by Fila, Justin on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "MMCharacter.h"
#include "PathFinder.h"

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

- (void)addDirectionsToStack:(CCArray *)directions
{
   NSLog(@"traveler key: %@", _travelerKey);
   CharacterDirection direction;
   for (NSNumber *directionNumber in directions)
   {
      direction = (CharacterDirection)directionNumber.intValue;
      NSLog(@"  direction: %d", direction);
      [self pushMoveStack:direction];
   }
}

- (void)calculatePathToCharacter:(MMCharacter *)character
{
   [self clearMoveStack];
   CCArray *directions = _pathFinder->calculatePath(_currentTile,
                                                    character.currentTile);
   [self addDirectionsToStack:directions];
}

- (void)beginExecutingCurrentPath
{
   _direction = [self popMoveStack];
   _isMoving = YES;
   _shouldMove = YES;
}

@end
