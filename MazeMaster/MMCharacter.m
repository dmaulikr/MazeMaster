//
//  MMCharacter.m
//  MazeMaster
//
//  Created by Fila, Justin on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "MMCharacter.h"

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
      direction = directionNumber.intValue;
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
      direction = directionNumber.intValue;
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


@end
