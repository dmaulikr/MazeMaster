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

@class PlayerLayer;
@interface GameLayer : CCLayer
{
   CGSize _windowSize;
   CGSize _tileSize;
   CGSize _subtileSize;

   float _topPadding;
   float _leftPadding;
   
   CGRect _gameBounds;

   PlayerLayer *_player;
   Player *_playerSprite;
}

+ (CCScene *)scene;
@end
