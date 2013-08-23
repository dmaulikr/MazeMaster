//
//  Level.m
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "Level.h"

@implementation Level

@synthesize levelNumber = _levelNumber;
@synthesize maze = _maze;

-(id) init
{
   if ( self = [super init] )
   {
      _maze = [[Maze alloc] initWithRows:5 withColumns:4];
      
      [_maze testMaze];
   }
   return self;
}

- (id)initWithLevelNumber:(int)levelNumber
{
   _levelNumber = levelNumber;
   return [self init];
}

-(void) dealloc
{
   [_maze release];
   
   [super dealloc];
}

@end
