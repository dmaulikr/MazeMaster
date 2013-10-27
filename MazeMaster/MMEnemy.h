//
//  MMEnemy.h
//  MazeMaster
//
//  Created by Fila, Justin on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "MMCharacter.h"

typedef enum {
   e_Wandering,
   e_Chasing
} EnemyState;

@interface MMEnemy : MMCharacter

-(id) initWithFile:(NSString *)filename;
-(void) attack;

+(MMEnemy *) enemyWithFile:(NSString *)filename;

@property (readwrite, assign) EnemyState state;
@property (readwrite, assign) BOOL shouldCalculateNewPath;
@property (readwrite, retain) MMCharacter *target;

@end
