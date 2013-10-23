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
   e_NORTH = 1, // binary: 0001
   e_EAST = 2,  // binary: 0010
   e_SOUTH = 4, // binary: 0100
   e_WEST = 8   // binary: 1000
} PlayerDirection;

#endif
