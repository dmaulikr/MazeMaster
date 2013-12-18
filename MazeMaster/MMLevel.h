//
//  MMLevel.h
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMMaze;
@class MMCharacter;
@class MMTile;
@interface MMLevel : NSObject

-(id) initWithRows:(int)rows andColumns:(int)cols;
-(void) addEnemiesToLayer:(CCLayer *)gameLayer;
- (void)setEnemyTargets:(MMTile *)tile;
- (void)setEnemyPositions;

@property (nonatomic, assign, setter = setLevelNumber:) int levelNumber;
@property (nonatomic, assign) MMMaze *maze;
@property (nonatomic, readwrite, retain) NSMutableArray *enemies;

@end
