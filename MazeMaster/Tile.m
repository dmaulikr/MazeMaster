//
//  Tile.m
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "Tile.h"
#import "Edge.h"

static const NSString *s_parent = @"parent";
static const NSString *s_cost = @"cost";
static const NSString *s_heuristic = @"heuristic";

@interface Tile()
{
   NSMutableDictionary *_pathingAttribueMap;
}
@end

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
      _pathingAttribueMap = [NSMutableDictionary new];
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
   [_pathingAttribueMap release];
   
   [super dealloc];
}

- (Tile *)getAdjacentTileForDirection:(CharacterDirection)direction
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

- (Edge *)getAdjacentEdgeForDirection:(CharacterDirection)direction
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
   
   if (_northEdge.walkable && !_northEdge.northTile.isActive)
      [neighbors addObject:_northEdge.northTile];
   if (_eastEdge.walkable && !_eastEdge.eastTile.isActive)
      [neighbors addObject:_eastEdge.eastTile];
   if (_southEdge.walkable && !_southEdge.southTile.isActive)
      [neighbors addObject:_southEdge.southTile];
   if (_westEdge.walkable && !_westEdge.westTile.isActive)
      [neighbors addObject:_westEdge.westTile];

   if (neighbors.count == 0)
      return nil;

   return neighbors;
}

- (CharacterDirection)directionFromParent
{
   Tile *parent = self.parent;
   if ([parent isEqual:_northEdge.northTile])
      return e_SOUTH;
   if ([parent isEqual:_eastEdge.eastTile])
      return e_WEST;
   if ([parent isEqual:_southEdge.southTile])
      return e_NORTH;
   if ([parent isEqual:_westEdge.westTile])
      return e_EAST;

   return e_NONE;
}

- (CharacterDirection)directionToParent
{
   Tile *parent = self.parent;
   if ([parent isEqual:_northEdge.northTile])
      return e_NORTH;
   if ([parent isEqual:_eastEdge.eastTile])
      return e_EAST;
   if ([parent isEqual:_southEdge.southTile])
      return e_SOUTH;
   if ([parent isEqual:_westEdge.westTile])
      return e_WEST;

   return e_NONE;
}

- (void)setParent:(Tile *)parent
{
   NSMutableDictionary *tileAttributes = [_pathingAttribueMap objectForKey:_travelerKey];
   if (!tileAttributes)
      tileAttributes = [NSMutableDictionary new];

   [tileAttributes setObject:(parent) ? parent : [NSNull null]
                      forKey:s_parent];

   [_pathingAttribueMap setObject:tileAttributes
                           forKey:_travelerKey];
}

- (Tile *)parent
{
   if ([[[_pathingAttribueMap objectForKey:_travelerKey] objectForKey:s_parent] isKindOfClass:[NSNull class]])
      return nil;
   else
      return [[_pathingAttribueMap objectForKey:_travelerKey] objectForKey:s_parent];
}

- (void)setCost:(int)cost
{
   NSMutableDictionary *tileAttributes = [_pathingAttribueMap objectForKey:_travelerKey];
   if (!tileAttributes)
      tileAttributes = [NSMutableDictionary new];

   [tileAttributes setObject:[NSNumber numberWithInt:cost]
                      forKey:s_cost];

   [_pathingAttribueMap setObject:tileAttributes
                           forKey:_travelerKey];
}

- (int)cost
{
   return [[[_pathingAttribueMap objectForKey:_travelerKey] objectForKey:s_cost] intValue];
}

- (void)setHeuristic:(float)heuristic
{
   NSMutableDictionary *tileAttributes = [_pathingAttribueMap objectForKey:_travelerKey];
   if (!tileAttributes)
      tileAttributes = [NSMutableDictionary new];

   [tileAttributes setObject:[NSNumber numberWithFloat:heuristic]
                      forKey:s_heuristic];

   [_pathingAttribueMap setObject:tileAttributes
                           forKey:_travelerKey];
}

- (float)heuristic
{
   return [[[_pathingAttribueMap objectForKey:_travelerKey] objectForKey:s_heuristic] floatValue];
}

- (float)optimality
{
   return self.cost + self.heuristic;
}

@end
