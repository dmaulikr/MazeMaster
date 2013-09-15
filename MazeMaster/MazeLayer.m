//
//  MazeLayer.m
//  MazeMaster
//
//  Created by Gregory Klein on 9/7/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "MazeLayer.h"
#import "Maze.h"

@implementation MazeLayer

@synthesize mazeSize = _mazeSize;

- (id)init
{
   if (self = [super init])
   {
      _windowSize = [[CCDirector sharedDirector] winSize];
      _tileSize = CGSizeMake(44, 44);
   }
   return self;
}

- (void)setupVariablesWithMaze:(Maze *)maze
{
   _mazeSize.width = _tileSize.width*maze.mazeDimensions.cols;
   _mazeSize.height = _tileSize.height*maze.mazeDimensions.rows;
}

- (void)setupMazeTilesForMaze:(Maze *)maze
{
   int rows = maze.mazeDimensions.rows;
   int cols = maze.mazeDimensions.cols;
   for (int row = 0; row < rows; ++row)
   {
      for (int col = 0; col < cols; ++col)
      {
         CCSprite *tileSprite = [CCSprite spriteWithFile:@"gray_tile_44x44.png"];
         tileSprite.anchorPoint = CGPointZero;
         tileSprite.position = ccp(col*_tileSize.width,
                                   row*_tileSize.height);
         [self addChild:tileSprite];
      }
   }
}

- (void)setupMazeEdgesWithMaze:(Maze *)maze
{
   NSLog(@"setting up maze edges");
}

- (id)initWithMaze:(Maze *)maze
{
   if (self = [self init])
   {
      [self setupVariablesWithMaze:maze];
      [self setupMazeTilesForMaze:maze];
      [self setupMazeEdgesWithMaze:maze];
   }
   return self;
}

- (void)dealloc
{
   [super dealloc];
}

+ (CCScene *)scene
{
	CCScene *scene = [CCScene node];
	MazeLayer *mazeLayer = [MazeLayer node];
   [scene addChild:mazeLayer];
	return scene;
}

@end
