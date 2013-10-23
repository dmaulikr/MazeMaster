//
//  PathFinder.h
//  MazeMaster
//
//  Created by Gregory Klein on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#ifndef __MazeMaster__PathFinder__
#define __MazeMaster__PathFinder__

@class Tile;

class PathFinder
{
 public:
   PathFinder();
   ~PathFinder();
   CCArray* calculatePath(Tile *start, Tile *goal);
 private:
};

#endif /* defined(__MazeMaster__PathFinder__) */
