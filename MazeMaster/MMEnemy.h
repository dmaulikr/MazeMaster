//
//  MMEnemy.h
//  MazeMaster
//
//  Created by Fila, Justin on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "MMCharacter.h"

@interface MMEnemy : MMCharacter
{
}

-(id) initWithFile:(NSString *)filename;
-(void) attack;

+(MMEnemy *) enemyWithFile:(NSString *)filename;

@property (readwrite, assign) BOOL shouldChasePlayer;
//@property (readwrite, assign) BOOL 

@end