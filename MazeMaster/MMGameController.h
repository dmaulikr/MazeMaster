//
//  MMGameController.h
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMCharacter;
@class MMGameLayer;
@class MMLevel;
@class MMTile;

@interface MMGameController : NSObject

+(MMGameController *) sharedController;

@property (nonatomic, assign) MMLevel *level;
@property (readwrite, assign) MMGameLayer *gameLayer;

-(BOOL) character:(MMCharacter *)character
  canMoveFromTile:(MMTile *)tile;
@end
