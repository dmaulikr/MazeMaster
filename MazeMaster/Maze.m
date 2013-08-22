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

@synthesize tiles = _tiles;

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
            // add the tile at the index
            [subArray addObject:[[Tile alloc] init]];
         }
         
         [_tiles addObject:subArray];
         // needs to be released here because the reference count is
         // increased when it is added into an array
         [subArray release];
      }
      
      // now connect all the edges
      [self connectEdges:rows cols:cols];
   }
   return self;
}

-(void) addNorthEdgeToTile:(Tile *)tile atX:(int)x andY:(int)y
{
   Edge *edge = tile.northEdge;
   if ( edge == nil )
   {
      edge = [[Edge alloc] init]; // create the north edge
      edge.southTile = tile;
   }
   
   edge.northTile = [[_tiles objectAtIndex:x] objectAtIndex:y];
   edge.northTile.southEdge = edge;
}

-(void) addEastEdgeToTile:(Tile *)tile atX:(int)x andY:(int)y
{
   Edge *edge = tile.eastEdge;
   if ( edge == nil )
   {
      edge = [[Edge alloc] init]; // create the east edge
      edge.westTile = tile;
   }
   
   edge.eastTile = [[_tiles objectAtIndex:x] objectAtIndex:y];
   edge.eastTile.westEdge = edge;
}

-(void) addSouthEdgeToTile:(Tile *)tile atX:(int)x andY:(int)y
{
   Edge *edge = tile.southEdge;
   if ( edge == nil )
   {
      edge = [[Edge alloc] init];
      edge.northTile = tile;
   }
   
   edge.southTile = [[_tiles objectAtIndex:x] objectAtIndex:y];
   edge.southTile.northEdge = edge;
}

-(void) addWestEdgeToTile:(Tile *)tile atX:(int)x andY:(int)y
{
   Edge *edge = tile.westEdge;
   if ( edge == nil )
   {
      edge = [[Edge alloc] init];
      edge.eastTile = tile;
   }
   
   edge.westTile = [[_tiles objectAtIndex:x] objectAtIndex:y];
   edge.westTile.eastEdge = edge;
}

-(void) connectEdges:(int)rows cols:(int)cols
{
   for (int i = 0; i < rows; i++)
   {
      for (int j = 0; j < cols; j++)
      {
         // grab the tile at that index
         Tile *tile = [[_tiles objectAtIndex:i] objectAtIndex:j];
         int x, y;
         
         // connect north edge to tile
         x = i;
         y = j + 1;
         if ( x >= 0 && y >= 0 && x < rows && y < cols )
            [self addNorthEdgeToTile:tile atX:x andY:y];
      
         // connect east edge to tile
         x = i + 1;
         y = j;
         if ( x >= 0 && y >= 0 && x < rows && y < cols )
            [self addEastEdgeToTile:tile atX:x andY:y];
         
         // connect south edge to tile
         x = i;
         y = j - 1;
         if ( x >= 0 && y >= 0 && x < rows && y < cols)
            [self addSouthEdgeToTile:tile atX:x andY:y];
         
         // connect west edge to tile
         x = i - 1;
         y = j;
         if ( x >= 0 && y >= 0 && x < rows && y < cols)
            [self addWestEdgeToTile:tile atX:x andY:y];
      }
   }
}

-(void) testMaze
{
   int rows = [_tiles count];
   int cols;
   for (int i = 0; i < rows; i++)
   {
      cols = [[_tiles objectAtIndex:i] count];
      for (int j = 0; j < cols; j++)
      {
         NSLog(@"Tile %dx%d: %@", i, j, [[_tiles objectAtIndex:i] objectAtIndex:j]);
      }
   }
}

-(void) dealloc
{
   // remove all the objects recursively
   [_tiles release];
   
   [_tileWithPlayer release];
   
   [super dealloc];
}

@end
