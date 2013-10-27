//
//  GameLayer.h
//  MazeMaster
//
//  Created by Gregory Klein on 8/6/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ControlsLayer.h"
#import "PlayerTypedefs.h"
#import "MMCharacter.h"

@class MazeLayer;
@class Player;

@interface GameLayer : CCLayer <ControlsActionDelegate>

@property (readwrite, assign) Player *playerSprite;
@property (readwrite, assign) MazeLayer *mazeLayer;

- (id)initWithMaze:(MazeLayer *)mazeLayer;
- (void)moveCharacter:(MMCharacter *)character;
- (void)updateTileContainingCharacter:(MMCharacter *)character
                          forTileSize:(CGSize)tileSize;
+ (CCScene *)scene;

@end