//
//  MMMaze.h
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Player;
@class MMTile;

typedef struct {
   int rows;
   int cols;
} MazeDimensions;

@interface MMMaze : NSObject

@property (nonatomic, assign) NSMutableArray *tiles;
@property (readonly, assign) MazeDimensions mazeDimensions;

- (MMTile *)getTileAtLocation:(CGPoint)location
                forTileSize:(CGSize)tileSize;
- (MMTile *)getRandomTile;

-(void) testMaze;
-(id) initWithRows:(int)rows withColumns:(int)cols;
-(MMTile *) tileAtPosition:(CGPoint)tileCoordinates;

@end
