//
//  MazeLayer.h
//  MazeMaster
//
//  Created by Gregory Klein on 9/7/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MazeLayer : CCLayer
{
   CGSize _windowSize;
   CGSize _tileSize;
   CGSize _mazeSize;

   float _topPadding;
   float _leftPadding;
}

@property (readonly, assign) CGSize mazeSize;

- (id)initWithRows:(int)rows
           columns:(int)cols;

+ (CCScene *)scene;
@end
