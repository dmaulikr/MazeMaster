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

CCArray* PathFinder::calculatePath(Tile *start, Tile *goal)
{
   std::cout << "start: " << NSStringFromCGPoint(start.position).UTF8String << std::endl;
   std::cout << "goal: " << NSStringFromCGPoint(goal.position).UTF8String << std::endl;
   return  nil;
}
