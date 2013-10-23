//
//  PlayerTypedefs.h
//  MazeMaster
//
//  Created by Gregory Klein on 9/16/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#ifndef __PLAYER_DIRECTION__
typedef enum {
   e_NONE,
   e_NORTH,
   e_EAST,
   e_SOUTH,
   e_WEST
} PlayerDirection;

#define kNorthWalkable 1 // binary: 0001
#define kEastWalkable  2 // binary: 0010
#define kSouthWalkable 4 // binary: 0100
#define kWestWalkable  8 // binary: 1000

typedef unsigned WalkableDirections;

#endif
