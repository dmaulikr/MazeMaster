//
//  PathFinder.cpp
//  MazeMaster
//
//  Created by Gregory Klein on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#include "PathFinder.h"

#include <iostream>
#import "Tile.h"

PathFinder::PathFinder()
{
   std::cout << "constructing PathFinder" << std::endl;
}

PathFinder::~PathFinder()
{
   std::cout << "destructing PathFinder" << std::endl;
}

void PathFinder::getPathToTile(Tile *tile)
{
   NSString *location = NSStringFromCGPoint(tile.position);
   std::cout << "PathFinder: getting path to tile " << location.UTF8String << std::endl;
}
