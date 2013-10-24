//
//  PathFinder.cpp
//  MazeMaster
//
//  Created by Gregory Klein on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#include "PathFinder.h"
#import "GameController.h"

#include <iostream>
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

   return  nil;
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
   start.cost = 0;
   goal.parent = nil;

   int tileGeneration = 0;
   int cost = 0;

   Tile *current = nil;

   [open addObject:start];
   while ([open objectAtIndex:0] != goal)
   {
      current = [open objectAtIndex:0];
      [open removeObjectAtIndex:0];
      [closed addObject:current];

      for (Tile *neighbor in [current walkableNeighborTiles])
      {
         cost = current.cost + movement_cost(current, neighbor);
         neighbor.genID = ++tileGeneration;

         if ([open containsObject:neighbor] && (cost < neighbor.cost))
            [open removeObject:neighbor];

         if ([closed containsObject:neighbor] && (cost < neighbor.cost))
            [closed removeObject:neighbor];

         if (![open containsObject:neighbor] && ![closed containsObject:neighbor])
         {
            neighbor.cost = cost;
            neighbor.heuristic = manhattan_distance(neighbor.position, goal.position);
            neighbor.parent = current;
            [open addObject:neighbor];
            [open qsortUsingCFuncComparator:&PathFinder::compare_tiles];
         }
      }
   }
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

int PathFinder::compare_tiles(const void *lhs, const void *rhs)
{
   id iLHS = ((id *) lhs)[0];
   id iRHS = ((id *) rhs)[0];

   Tile *leftTile = (Tile *)iLHS;
   Tile *rightTile = (Tile *)iRHS;

   return ((leftTile.optimality > rightTile.optimality) &&
           (leftTile.genID < rightTile.genID)); // for tie-breakers
}
