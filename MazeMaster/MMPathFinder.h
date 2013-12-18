//
//  MMPathFinder.h
//  MazeMaster
//
//  Created by Gregory Klein on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#ifndef __MazeMaster__PathFinder__
#define __MazeMaster__PathFinder__

#include "MMPlayerTypedefs.h"

@class MMTile;
class MMPathFinder
{
 public:
   MMPathFinder(NSString *travelerKey);
   ~MMPathFinder();
   CCArray* calculatePath(MMTile *start, MMTile *goal);
   void setTileGenerationOrder(TileGenerationOrder order);

private:
   int manhattan_distance(CGPoint current, CGPoint goal) const;
   int movement_cost(MMTile *from, MMTile *to);

   void astar_search(MMTile *start, MMTile *goal);
   void add_tile_to_open(MMTile *tile, CCArray *open);
   
   void print_path(MMTile *tile);
   CCArray* get_directions(MMTile *goal);

   NSString *_travelerKey;
   TileGenerationOrder _tileGenerationOrder;
};

#endif /* defined(__MazeMaster__PathFinder__) */
