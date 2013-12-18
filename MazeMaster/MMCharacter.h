//
//  MMCharacter.h
//  MazeMaster
//
//  Created by Fila, Justin on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "CCSprite.h"
#import "MMPlayerTypedefs.h"

@class MMTile;
@interface MMCharacter : CCSprite

+(MMCharacter *) characterWithFile:(NSString *)filename;

-(id) initWithFile:(NSString *)filename;
- (id)initWithFile:(NSString *)filename
       travelerKey:(NSString *)travelerKey;

- (void)pushMoveStack:(CharacterDirection)direction;
- (CharacterDirection)popMoveStack;
- (CharacterDirection)topMoveStack;
- (void)clearMoveStack;
- (BOOL)moveStackIsEmpty;

- (void)setupPathFinderWithTravelerKey:(NSString *)travelerKey;
- (BOOL)calculatePathToTile:(MMTile *)tile;
- (void)beginExecutingCurrentPath;

- (void)stopMoving;
- (CGPoint)getDirectionPoint;
- (void)updatePositionWithCurrentDirection;
- (void)updatePositionForTile:(MMTile *)nextTile
                   atLocation:(CGPoint)nextTileLocation
                 mazeMovement:(BOOL)mazeMoving;
- (void)updateCurrentTileForMazeMovement:(BOOL)mazeMoving;
- (void)evaluateStateAndPotentiallyCalculatePathInTheFuture;
- (void)attack;

@property (readwrite, assign) NSString *travelerKey;
@property (nonatomic, assign, setter = setTileGenerationOrder:) TileGenerationOrder tileGenerationOrder;
@property (readwrite, assign) CGPoint velocity;
@property (readwrite, assign) CGPoint maxVelocity;
@property (readwrite, assign) CGPoint offset;
@property (nonatomic, assign) CharacterDirection direction;
@property (readwrite, assign) BOOL isMoving;
@property (readwrite, assign) BOOL shouldMove;
@property (readwrite, assign) BOOL isPlayer;
@property (nonatomic, assign, setter = setCurrentTile:) MMTile *currentTile;
@end
