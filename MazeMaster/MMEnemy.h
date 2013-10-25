//
//  MMEnemy.h
//  MazeMaster
//
//  Created by Fila, Justin on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "MMCharacter.h"
#import "Tile.h"

@interface MMEnemy : MMCharacter
{
}

-(id) initWithFile:(NSString *)filename;
-(void) attack;

+(MMEnemy *) enemyWithFile:(NSString *)filename;

@end
