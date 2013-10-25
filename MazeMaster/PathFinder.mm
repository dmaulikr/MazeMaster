//
//  PathFinder.cpp
//  MazeMaster
//
//  Created by Gregory Klein on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#include "PathFinder.h"
#include <iostream>

#import "GameController.h"
#import "Tile.h"

// ----- Public Methods -----
PathFinder::PathFinder()
{
   std::cout << "constructing PathFinder..." << std::endl;
}

PathFinder::~PathFinder()
{
   std::cout << "destructing PathFinder..." << std::endl;
}

CCArray* PathFinder::calculatePath(Tile *start, Tile *goal)
{
   astar_search(start, goal);
   return get_directions(goal);
}

// ----- Private Methods -----
int PathFinder::manhattan_distance(CGPoint current, CGPoint goal) const
{
   return abs(goal.x - current.x) + abs(goal.y - current.y);
}

int PathFinder::movement_cost(Tile *from, Tile *to)
{
   return 1;
}

void PathFinder::astar_search(Tile *start, Tile *goal)
{
   CCArray *open = [CCArray array];
   CCArray *closed = [CCArray array];

   start.parent = nil;
   goal.parent = nil;

   start.cost = 0;
   [open addObject:start];

   int cost = 0;
   Tile *current = nil;

   while (open.count && [open objectAtIndex:0] != goal)
   {
      current = [open objectAtIndex:0];
      [open removeObjectAtIndex:0];
      [closed addObject:current];

      for (Tile *neighbor in [current walkableNeighborTiles])
      {
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

void PathFinder::add_tile_to_open(Tile *tile, CCArray *open)
{
   float optimality = tile.optimality;
   int i = 0;
   for (; i < open.count; ++i)
      if (optimality < [[open objectAtIndex:i] optimality])
         break;

   [open insertObject:tile atIndex:i];
}

void PathFinder::print_path(Tile *tile)
{
   std::cout << "from: " << NSStringFromCGPoint(tile.position).UTF8String << std::endl;
   Tile *current = tile.parent;
   while (current)
   {
      std::cout << "pos: " << NSStringFromCGPoint(current.position).UTF8String << std::endl;
      current = current.parent;
   }
}

CCArray* PathFinder::get_directions(Tile *goal)
{
   if (!goal.parent)
      return nil;

   CCArray *directions = [CCArray new];
   Tile *current = goal;
   while (current)
   {
      if (current.parent)
         [directions addObject:[NSNumber numberWithInt:current.directionFromParent]];

      current = current.parent;
   }

   [directions reverseObjects];
   return directions;
}
