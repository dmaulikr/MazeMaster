//
//  Game.h
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "PlayerTypedefs.h"

@class GameLayer;
@class Level;
@class Tile;

@interface GameController : NSObject
{
   NSMutableArray *_swipeStack;
}

+(GameController *) sharedController;

@property (nonatomic, assign) Level *level;
@property (readwrite, assign) GameLayer *gameLayer;

-(BOOL) canMoveFromTile:(Tile *)tile
            inDirection:(CharacterDirection)direction;

@end
