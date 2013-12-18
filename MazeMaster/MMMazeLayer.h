//
//  MMMazeLayer.h
//  MazeMaster
//
//  Created by Gregory Klein on 9/7/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class MMMaze;
@interface MMMazeLayer : CCLayer

@property (readonly, assign) CGSize mazeSize;

- (id)initWithMaze:(MMMaze *)maze;
+ (CCScene *)scene;

@end
