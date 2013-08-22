//
//  Game.h
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Level.h"

typedef enum
{
   e_NORTH,
   e_EAST,
   e_SOUTH,
   e_WEST
} PlayerDirection;

@interface GameController : NSObject
{
   PlayerDirection _playerDirection;
}

+(GameController *) gameController;
-(void) movePlayer;

@property (nonatomic, assign) Level *level;
@property (nonatomic, assign) PlayerDirection playerDirection;

@end
