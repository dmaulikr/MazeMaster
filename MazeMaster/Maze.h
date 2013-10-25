//
//  Maze.h
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tile.h"

@class Player;

typedef struct {
   int rows;
   int cols;
} MazeDimensions;

@interface Maze : NSObject
{
   MazeDimensions _mazeDimensions;
   
   NSMutableArray* _tiles;
}

@property (nonatomic, assign) NSMutableArray *tiles;
@property (readonly, assign) MazeDimensions mazeDimensions;

- (Tile *)getTileAtLocation:(CGPoint)location
                forTileSize:(CGSize)tileSize;

-(void) testMaze;
-(id) initWithRows:(int)rows withColumns:(int)cols;
-(Tile *) tileAtPosition:(CGPoint)tileCoordinates;

@end
