//
//  Game.h
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMCharacter;
@class GameLayer;
@class Level;
@class Tile;

@interface GameController : NSObject

+(GameController *) sharedController;

@property (nonatomic, assign) Level *level;
@property (readwrite, assign) GameLayer *gameLayer;

-(BOOL) character:(MMCharacter *)character
  canMoveFromTile:(Tile *)tile;
@end
