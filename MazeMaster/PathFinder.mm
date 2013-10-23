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

PathFinder::PathFinder()
{
   std::cout << "constructing PathFinder..." << std::endl;
}

PathFinder::~PathFinder()
{
   std::cout << "destructing PathFinder..." << std::endl;
}

void PathFinder::getPathToTile(Tile *tile)
{
   NSString *location = NSStringFromCGPoint(tile.position);
   std::cout << "PathFinder: getting path to tile " << location.UTF8String << std::endl << std::endl;

   WalkableDirections direcitons =
      [[GameController sharedController] getWalkableDirectionsFromTile:tile];

   int mask = 1;
   std::cout << "north walkable: " << ((direcitons >> 0) & mask) << std::endl;
   std::cout << "east walkable: " << ((direcitons >> 1) & mask) << std::endl;
   std::cout << "south walkable: " << ((direcitons >> 2) & mask) << std::endl;
   std::cout << "west walkable: " << ((direcitons >> 3) & mask) << std::endl;
}
