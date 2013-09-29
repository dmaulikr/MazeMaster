//
//  Maze.m
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "Maze.h"
#import "Tile.h"
#import "Player.h"

@implementation Maze

@synthesize tiles = _tiles;
@synthesize mazeDimensions = _mazeDimensions;

-(id) initWithRows:(int)rows withColumns:(int)cols
{
   if ( self = [super init] )
   {
      _mazeDimensions.rows = rows;
      _mazeDimensions.cols = cols;
      _tiles = [[NSMutableArray alloc] init];
      
      // create the 2d array
      for (int i = 0; i < rows; i++)
      {
         NSMutableArray *subArray = [[NSMutableArray alloc] init];
         for (int j = 0; j < cols; j++)
         {
            // add the tile at the index
            Tile *tile = [[Tile alloc] init];
            tile.position = CGPointMake(j+1, i+1);
            [subArray addObject:tile];
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

-(void) updateTileContainingPlayer:(CGSize)tileSize withPosition:(CGPoint)playerPosition withPlayer:(Player *)player
{
   // check the position of the player versus the position on the maze
   
//   int xTile = ((playerPosition.x + (tileSize.width / 2) + ((player.boundingBox.size.width) / 2)) / tileSize.width) + 1;
//   int yTile = ((playerPosition.y + (tileSize.height / 2) + ((player.boundingBox.size.height)/ 2)) / tileSize.height) + 1;
   
   int xTile = (playerPosition.x / tileSize.width) + 1;
   int yTile = (playerPosition.y / tileSize.height) + 1;
   
//   NSLog(@"tilex: %d  tiley: %d  playerPosition: %fx%f", xTile, yTile, playerPosition.x, playerPosition.y);

   _tileWithPlayer = [self tileAtPosition:CGPointMake(xTile, yTile)];
}

-(Tile *) tileAtPosition:(CGPoint)tileCoordinates
{
   return [[_tiles objectAtIndex:tileCoordinates.y - 1] objectAtIndex:tileCoordinates.x - 1];
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
   _mazeDimensions.rows = nil;
   _mazeDimensions.cols = nil;
   
   // remove all the objects recursively
   [_tiles release];
   [_tileWithPlayer release];
   
   [super dealloc];
}

@end
