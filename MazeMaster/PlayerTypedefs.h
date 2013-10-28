//
//  PlayerTypedefs.h
//  MazeMaster
//
//  Created by Gregory Klein on 9/16/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#ifndef __CHARACTER_DIRECTION__
typedef enum {
   e_NONE,
   e_NORTH,
   e_EAST,
   e_SOUTH,
   e_WEST
} CharacterDirection;
#endif

#ifndef __TILE_GENERATION_ORDER__
typedef enum {
   e_CLOCKWISE,
   e_COUNTERCLOCKWISE
} TileGenerationOrder;
#endif

#ifndef __TILE_STATE__
typedef enum {
   e_INACTIVE,
   e_WILL_BE_ACTIVE,
   e_ACTIVE
} TileState;
#endif

#ifndef __ENEMY_STATE__
typedef enum {
   e_SLEEPING,
   e_WANDERING,
   e_CHASING
} EnemyState;
#endif
