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
   int manhattan_distance(CGPoint current, CGPoint goal) const;
   int movement_cost(Tile *from, Tile *to);

   void astar_search(Tile *start, Tile *goal);
   void print_path(Tile *tile);

   CCArray* get_directions(Tile *goal);

   static int compare_tiles(const void *, const void *);
};

#endif /* defined(__MazeMaster__PathFinder__) */
