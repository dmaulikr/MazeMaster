//
//  Maze.m
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "Maze.h"
#import "Tile.h"

@implementation Maze

-(id) initWithRows:(int)rows withColumns:(int)cols
{
   if ( self = [super init] )
   {
      _tiles = [[NSMutableArray alloc] init];
      
      // create the 2d array
      for (int i = 0; i < rows; i++)
      {
         NSMutableArray *subArray = [[NSMutableArray alloc] init];
         for (int j = 0; j < cols; j++)
         {
            // add one tile at each index
            [subArray addObject:[[Tile alloc] init]];
         }
         
         [_tiles addObject:subArray];
         // needs to be released here because the reference count is
         // increased when it is added into an array
         [subArray release];
      }
   }
   return self;
}

-(void) dealloc
{
   [super dealloc];
   
   // remove all the objects recursively
   int rows = [_tiles count];
   for (int i = 0; i < rows; i++)
   {
      NSMutableArray *subarray = [_tiles objectAtIndex:rows];
      int cols = [subarray count];
      for (int j = 0; j < [subarray count]; j++)
      {
         [subarray removeObjectAtIndex:cols];
      }
   }
   
   [_tiles release];
   [_tileWithPlayer release];
}

@end
