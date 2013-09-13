//
//  GameLayer.h
//  MazeMaster
//
//  Created by Gregory Klein on 8/6/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class MazeLayer;
@class Player;
@interface GameLayer : CCLayerColor
{
   CGSize _windowSize;
   CGSize _tileSize;
   CGSize _subtileSize;

   int _outsideEdgePadding;
   int _insideEdgePadding;

   NSRange _verticalCenterRange;
   NSRange _horizontalCenterRange;
   
   CGRect _gameBounds;

   MazeLayer *_mazeLayer;
   Player *_playerSprite;

   BOOL _moveMaze;
}

- (id)initWithMaze:(MazeLayer *)mazeLayer;
-(void)movePlayerByX:(int)x andY:(int)y;
+ (CCScene *)scene;

@end
