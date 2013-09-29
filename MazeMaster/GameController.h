//
//  Game.h
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Level.h"
#import "GameLayer.h"
#import "PlayerTypedefs.h"

@interface GameController : NSObject
{
   PlayerDirection _playerDirection;
   GameLayer *_gameLayer;
   BOOL _isPlayerMoving;
}

+(GameController *) gameController;

@property (nonatomic, assign) Level *level;
@property (nonatomic, assign) PlayerDirection playerDirection;
@property (readwrite, assign) GameLayer *gameLayer;
@property (readwrite, assign) BOOL isPlayerMoving;

@end
