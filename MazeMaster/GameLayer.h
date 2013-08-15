//
//  GameLayer.h
//  MazeMaster
//
//  Created by Gregory Klein on 8/6/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameLayer : CCLayer
{
   CGSize _windowSize;
   CGSize _tileSize;
   CGSize _subtileSize;
   float _topPadding;
   float _leftPadding;
}

+ (CCScene *)scene;
@end
