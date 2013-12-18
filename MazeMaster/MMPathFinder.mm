//
//  MMPathFinder.cpp
//  MazeMaster
//
//  Created by Gregory Klein on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#include "MMPathFinder.h"
#include <iostream>

#import "MMGameController.h"
#import "MMTile.h"

// ----- Public Methods -----
MMPathFinder::MMPathFinder(NSString *travelerKey)
{
   _travelerKey = travelerKey;
   _tileGenerationOrder = e_CLOCKWISE;
   std::cout << "constructing PathFinder..." << std::endl;
}

MMPathFinder::~MMPathFinder()
{
   [_travelerKey release];
   std::cout << "destructing PathFinder..." << std::endl;
}

CCArray* MMPathFinder::calculatePath(MMTile *start, MMTile *goal)
{
   astar_search(start, goal);
   return get_directions(goal);
}

void MMPathFinder::setTileGenerationOrder(TileGenerationOrder order)
{
   _tileGenerationOrder = order;
}

// ----- Private Methods -----
int MMPathFinder::manhattan_distance(CGPoint current, CGPoint goal) const
{
   return abs(goal.x - current.x) + abs(goal.y - current.y);
}

int MMPathFinder::movement_cost(MMTile *from, MMTile *to)
{
   return 1;
}

void MMPathFinder::astar_search(MMTile *start, MMTile *goal)
{
   CCArray *open = [CCArray array];
   CCArray *closed = [CCArray array];
   CCArray *neighbors = [CCArray array];

   start.travelerKey = _travelerKey;
   goal.travelerKey = _travelerKey;

   start.parent = nil;
   goal.parent = nil;

   start.cost = 0;
   [open addObject:start];

   int cost = 0;
   MMTile *current = nil;

   while (open.count && [open objectAtIndex:0] != goal)
   {
      current = [open objectAtIndex:0];
      [open removeObjectAtIndex:0];
      [closed addObject:current];

      neighbors = [current walkableNeighborTiles];
      if (_tileGenerationOrder == e_COUNTERCLOCKWISE)
         [neighbors reverseObjects];

      for (MMTile *neighbor in neighbors)
      {
         neighbor.travelerKey = _travelerKey;
         cost = current.cost + movement_cost(current, neighbor);

         if ([open containsObject:neighbor] && (cost < neighbor.cost))
            [open removeObject:neighbor];

         if ([closed containsObject:neighbor] && (cost < neighbor.cost))
            [closed removeObject:neighbor];

         if (![open containsObject:neighbor] && ![closed containsObject:neighbor])
         {
            neighbor.cost = cost;
            neighbor.heuristic = manhattan_distance(neighbor.position, goal.position);
            neighbor.parent = current;
            add_tile_to_open(neighbor, open);
         }
      }
   }
}

void MMPathFinder::add_tile_to_open(MMTile *tile, CCArray *open)
{
   float optimality = tile.optimality;
   int i = 0;
   for (; i < open.count; ++i)
      if (optimality < [[open objectAtIndex:i] optimality])
         break;

   [open insertObject:tile atIndex:i];
}

void MMPathFinder::print_path(MMTile *tile)
{
   std::cout << "from: " << NSStringFromCGPoint(tile.position).UTF8String << std::endl;
   MMTile *current = tile.parent;
   while (current)
   {
      std::cout << "pos: " << NSStringFromCGPoint(current.position).UTF8String << std::endl;
      current = current.parent;
   }
}

CCArray* MMPathFinder::get_directions(MMTile *goal)
{
   if (!goal.parent)
      return nil;

   CCArray *directions = [CCArray new];
   MMTile *current = goal;
   while (current)
   {
      current.travelerKey = _travelerKey;
      if (current.parent)
         [directions addObject:[NSNumber numberWithInt:current.directionFromParent]];

      current = current.parent;
   }

   [directions reverseObjects];
   return directions;
}
