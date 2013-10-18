//
//  PathFinder.h
//  MazeMaster
//
//  Created by Gregory Klein on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#ifndef __MazeMaster__PathFinder__
#define __MazeMaster__PathFinder__

#include <iostream>

@class Tile;
class PathFinder
{
 public:
   PathFinder();
   ~PathFinder();

   void getPathToTile(Tile *tile);
 private:
};

#endif /* defined(__MazeMaster__PathFinder__) */
