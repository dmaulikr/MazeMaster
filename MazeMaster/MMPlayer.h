//
//  MMPlayer.h
//  MazeMaster
//
//  Created by Justin Fila on 8/19/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MMCharacter.h"

@interface MMPlayer : MMCharacter

-(id) initWithFile:(NSString *)filename;
-(void) attack;
- (void)stopMoving;
+(MMPlayer *) playerWithFile:(NSString *)filename;

@end
