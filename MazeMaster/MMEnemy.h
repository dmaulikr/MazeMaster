//
//  MMEnemy.h
//  MazeMaster
//
//  Created by Fila, Justin on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "MMCharacter.h"

@interface MMEnemy : MMCharacter

-(id) initWithFile:(NSString *)filename;
- (void)setAwarenessProximityWithSize:(CGSize)size;
- (void)examineAwarenessProximityForCharacter:(MMCharacter *)character;

+(MMEnemy *) enemyWithFile:(NSString *)filename;

@property (nonatomic, assign, setter = setState:) EnemyState state;
@property (readwrite, assign) BOOL shouldCalculateNewPath;
@property (readwrite, retain) MMTile *target;
@property (readwrite, assign) CGRect awarenessProximity;

@end