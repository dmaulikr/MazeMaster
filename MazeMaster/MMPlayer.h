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
#import "MMVictim.h"

@interface MMPlayer : MMCharacter

- (id) initWithFile:(NSString *)filename;
- (void) attack;
- (void) collisionCheckWithVictim;
+ (MMPlayer *) playerWithFile:(NSString *)filename;

@property (readwrite, assign) MMVictim *victim;


@end
