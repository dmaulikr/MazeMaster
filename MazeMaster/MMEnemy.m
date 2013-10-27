//
//  MMEnemy.m
//  MazeMaster
//
//  Created by Fila, Justin on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "MMEnemy.h"

@implementation MMEnemy

-(id)initWithFile:(NSString *)filename
{
   if (self = [super initWithFile:filename])
   {
      _state = e_SLEEPING;
      [self scheduleUpdate];
   }
   return self;
}

-(void) attack
{
   NSLog(@"Enemy attack");
}

+(MMEnemy *) enemyWithFile:(NSString *)filename
{
   // TODO: this is weird
   return (MMEnemy *)[super characterWithFile:filename];
}

- (void)update:(ccTime)delta
{
   if (_shouldCalculateNewPath)
   {
      [self calculatePathToCharacter:_target];
      [self beginExecutingCurrentPath];
      _shouldCalculateNewPath = NO;
   }
}

- (void)dealloc
{
   [super dealloc];
}

@end
