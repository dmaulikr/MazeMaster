//
//  ControlsLayer.h
//  MazeMaster
//
//  Created by Justin Fila on 8/19/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol ControlsActionDelegate <NSObject>
@optional
   - (void)handleTapAtLocation:(CGPoint)location;
   - (void)handleDoubleTapAtLocation:(CGPoint)location;
@end

@interface ControlsLayer : CCLayer <UIGestureRecognizerDelegate,
                                    CCTouchOneByOneDelegate>
{
   CGPoint _lastTouchLocation;
}

@property (readwrite, retain) id<ControlsActionDelegate> delegate;

@end
