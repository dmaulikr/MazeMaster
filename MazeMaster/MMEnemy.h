//
//  MMEnemy.h
//  MazeMaster
//
//  Created by Fila, Justin on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "MMCharacter.h"

typedef enum {
   e_SLEEPING,
   e_WANDERING,
   e_CHASING
} EnemyState;

@interface MMEnemy : MMCharacter

-(id) initWithFile:(NSString *)filename;
-(void) attack;

+(MMEnemy *) enemyWithFile:(NSString *)filename;

@property (readwrite, assign) EnemyState state;
@property (readwrite, assign) BOOL shouldCalculateNewPath;
@property (readwrite, retain) MMCharacter *target;

@end
