//
//  GameLayer.h
//  MazeMaster
//
//  Created by Gregory Klein on 8/6/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Level.h"
#import "Player.h"
#import "MazeLayer.h"

@interface GameLayer : CCLayer
{
   CGSize _windowSize;
   CGSize _tileSize;
   CGSize _subtileSize;

   float _topPadding;
   float _leftPadding;
   
   CGRect _gameBounds;

   MazeLayer *_mazeLayer;
   Player *_playerSprite;
}

- (id)initWithMaze:(MazeLayer *)mazeLayer;
-(void)movePlayerByX:(int)x andY:(int)y;
+ (CCScene *)scene;

@end
