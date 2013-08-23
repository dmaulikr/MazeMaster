//
//  Level.h
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Maze.h"

@interface Level : NSObject
{
   Maze* _maze;
   int _levelNumber;
}

@property (nonatomic, assign) int levelNumber;
@property (nonatomic, assign) Maze *maze;

- (id)initWithLevelNumber:(int)levelNumber;

@end
