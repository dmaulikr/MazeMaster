//
//  Tile.m
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "Tile.h"
#import "Edge.h"

@implementation Tile

@synthesize northEdge = _northEdge;
@synthesize eastEdge = _eastEdge;
@synthesize southEdge = _southEdge;
@synthesize westEdge = _westEdge;
@synthesize position = _position;
@synthesize tileSprite = _tileSprite;

-(id) init
{
   if ( self = [super init] )
   {
      // initialize stuff
   }
   return self;
}

-(NSString *) description
{
   NSString *string = [[NSString alloc] initWithFormat:
                       @"Tile: %p\n     northEdge %p\n     eastEdge %p\n     southEdge %p\n     westEdge %p",
                       self, _northEdge, _eastEdge, _southEdge, _westEdge];
   return string;
}

-(void) dealloc
{
   if ( _northEdge )
      [_northEdge release];
   
   if ( _eastEdge )
      [_eastEdge release];
   
   if ( _southEdge )
      [_southEdge release];
   
   if ( _westEdge )
      [_westEdge release];
   
   [_tileSprite release];
   
   [super dealloc];
}

- (Tile *)getAdjacentTileForDirection:(PlayerDirection)direction
{
   switch (direction)
   {
      case e_NORTH:
         return _northEdge.northTile;
      case e_SOUTH:
         return _southEdge.southTile;
      case e_EAST:
         return _eastEdge.eastTile;
      case e_WEST:
         return _westEdge.westTile;
      default:
         break;
   }
   return nil;
}

- (Edge *)getAdjacentEdgeForDirection:(PlayerDirection)direction
{
   switch (direction)
   {
      case e_NORTH:
         return _northEdge;
         break;
      case e_SOUTH:
         return _southEdge;
         break;
      case e_EAST:
         return _eastEdge;
         break;
      case e_WEST:
         return _westEdge;
         break;
      default:
         break;
   }
   return nil;
}

- (CCArray *)walkableNeighborTiles
{
   CCArray *neighbors = [CCArray arrayWithCapacity:4];
   
   if (_northEdge.walkable)
      [neighbors addObject:_northEdge.northTile];
   if (_eastEdge.walkable)
      [neighbors addObject:_eastEdge.eastTile];
   if (_southEdge.walkable)
      [neighbors addObject:_southEdge.southTile];
   if (_westEdge.walkable)
      [neighbors addObject:_westEdge.westTile];

   if (neighbors.count == 0)
      return nil;

   return neighbors;
}

- (PlayerDirection)directionFromParent
{
   if ([_parent isEqual:_northEdge.northTile])
      return e_SOUTH;
   if ([_parent isEqual:_eastEdge.eastTile])
      return e_WEST;
   if ([_parent isEqual:_southEdge.southTile])
      return e_NORTH;
   if ([_parent isEqual:_westEdge.westTile])
      return e_EAST;

   return e_NONE;
}

- (PlayerDirection)directionToParent
{
   if ([_parent isEqual:_northEdge.northTile])
      return e_NORTH;
   if ([_parent isEqual:_eastEdge.eastTile])
      return e_EAST;
   if ([_parent isEqual:_southEdge.southTile])
      return e_SOUTH;
   if ([_parent isEqual:_westEdge.westTile])
      return e_WEST;

   return e_NONE;
}

- (int)optimality
{
   return _cost + _heuristic;
}

@end
