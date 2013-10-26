//
//  MMCharacter.h
//  MazeMaster
//
//  Created by Fila, Justin on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "CCSprite.h"
#import "PlayerTypedefs.h"
#import "Tile.h"

@interface MMCharacter : CCSprite
{
   NSMutableArray *_moveStack;
}

@property (readwrite, assign) CGPoint velocity;
@property (readwrite, assign) CGPoint absolutePosition;
@property (readwrite, assign) CGPoint offset;
@property (nonatomic, assign) CharacterDirection direction;
@property (readwrite, assign) BOOL isMoving;
@property (readwrite, assign) BOOL shouldMove;
@property (readwrite, assign) BOOL isPlayer;
@property (readwrite, assign) Tile *currentTile;

-(id) initWithFile:(NSString *)filename;
-(void) attack;

-(void) pushMoveStack:(CharacterDirection)direction;
-(CharacterDirection) popMoveStack;
-(CharacterDirection) topMoveStack;
-(void) clearMoveStack;
-(BOOL) moveStackIsEmpty;

+(MMCharacter *) characterWithFile:(NSString *)filename;

@end
