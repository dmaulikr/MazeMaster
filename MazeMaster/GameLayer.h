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

@class MazeLayer;
@class Player;

struct Opaque;

@interface GameLayer : CCLayer <ControlsActionDelegate>
{
   CGSize _windowSize;
   CGSize _tileSize;

   int _outsideEdgePadding;

   NSRange _verticalCenterRange;
   NSRange _horizontalCenterRange;

   float _xPlayerOffset;
   float _yPlayerOffset;
   
   BOOL _moveMaze;

   struct Opaque *_opaque;
}

@property (readwrite, assign) Player *playerSprite;
@property (readwrite, assign) MazeLayer *mazeLayer;

- (id)initWithMaze:(MazeLayer *)mazeLayer;
- (void)movePlayer;
+ (CCScene *)scene;

@end