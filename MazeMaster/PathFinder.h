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

struct Node
{
   CGPoint pos;
   CCArray *neighbors;
   int f;
   int g;
   int h;
   struct Node *parent;
};

class PathFinder
{
 public:
   PathFinder();
   ~PathFinder();
   void getPathToTile(Tile *tile);
 private:
};

#endif /* defined(__MazeMaster__PathFinder__) */
