//
//  MMGameLayer.h
//  MazeMaster
//
//  Created by Gregory Klein on 8/6/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MMControlsLayer.h"
#import "MMCharacter.h"

@class MMMazeLayer;
@class MMPlayer;

@interface MMGameLayer : CCLayer <ControlsActionDelegate>

@property (readwrite, assign) MMPlayer *playerSprite;
@property (readwrite, assign) MMMazeLayer *mazeLayer;

- (id)initWithMaze:(MMMazeLayer *)mazeLayer;
- (void)setMazePositionForCharacter:(MMCharacter *)character
                 atNextTileLocation:(CGPoint)nextTileLocation;
+ (CCScene *)scene;

@end