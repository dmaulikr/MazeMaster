//
//  Level.m
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "Level.h"

@implementation Level

-(id) init
{
   if ( self = [super init] )
   {
      _maze = [[Maze alloc] init];
   }
   return self;
}

-(void) dealloc
{
   [super dealloc];
   
   [_maze release];
}

@end
