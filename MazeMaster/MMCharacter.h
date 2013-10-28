//
//  MMCharacter.h
//  MazeMaster
//
//  Created by Fila, Justin on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "CCSprite.h"
#import "PlayerTypedefs.h"

@class Tile;
@interface MMCharacter : CCSprite

+(MMCharacter *) characterWithFile:(NSString *)filename;

-(id) initWithFile:(NSString *)filename;
- (id)initWithFile:(NSString *)filename
       travelerKey:(NSString *)travelerKey;

-(void) pushMoveStack:(CharacterDirection)direction;
-(CharacterDirection) popMoveStack;
-(CharacterDirection) topMoveStack;
-(void) clearMoveStack;
-(BOOL) moveStackIsEmpty;

- (void)setupPathFinderWithTravelerKey:(NSString *)travelerKey;
- (BOOL)calculatePathToCharacter:(MMCharacter *)character;
- (void)beginExecutingCurrentPath;

-(void) attack;

@property (readwrite, assign) NSString *travelerKey;
@property (nonatomic, assign, setter = setTileGenerationOrder:) TileGenerationOrder tileGenerationOrder;
@property (readwrite, assign) CGPoint velocity;
@property (readwrite, assign) CGPoint maxVelocity;
@property (readwrite, assign) CGPoint absolutePosition;
@property (readwrite, assign) CGPoint offset;
@property (nonatomic, assign) CharacterDirection direction;
@property (readwrite, assign) BOOL isMoving;
@property (readwrite, assign) BOOL shouldMove;
@property (readwrite, assign) BOOL isPlayer;
@property (nonatomic, assign, setter = setCurrentTile:) Tile *currentTile;
@end
