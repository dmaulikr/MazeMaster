//
//  DoubleTouchDownRecognizer.m
//  MazeMaster
//
//  Created by Gregory Klein on 10/17/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "DoubleTouchDownRecognizer.h"
#import "GameController.h"

@implementation DoubleTouchDownRecognizer

-(void)touchesBegan:(NSSet *)touches
          withEvent:(UIEvent *)event
{
   if ([event allTouches].count == 2 &&
       self.state == UIGestureRecognizerStatePossible)
   {
      self.state = UIGestureRecognizerStateRecognized;
   }
}

-(void)touchesMoved:(NSSet *)touches
          withEvent:(UIEvent *)event
{
   self.state = UIGestureRecognizerStateFailed;
}

-(void)touchesEnded:(NSSet *)touches
          withEvent:(UIEvent *)event
{
   self.state = UIGestureRecognizerStateFailed;
}

@end
