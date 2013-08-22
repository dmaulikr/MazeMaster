//
//  Maze.h
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tile.h"

@interface Maze : NSObject
{
   Tile*       _tileWithPlayer;
   NSMutableArray*    _tiles;
}

@property (nonatomic, assign) NSMutableArray *tiles;

-(void) testMaze;
-(id) initWithRows:(int)rows withColumns:(int)cols;

@end
