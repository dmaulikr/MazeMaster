//
//  MMVictim.h
//  MazeMaster
//
//  Created by Justin Fila on 12/18/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "MMCharacter.h"

@interface MMVictim : MMCharacter
   
- (id) initWithFile:(NSString *)filename;
- (void) moveFromDelayToMoveStack;
+ (MMVictim *) victimWithFile:(NSString *)filename;

@property (nonatomic, assign, setter = setState:) VictimState state;

@end
