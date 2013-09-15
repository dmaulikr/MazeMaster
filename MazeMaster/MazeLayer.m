//
//  MazeLayer.m
//  MazeMaster
//
//  Created by Gregory Klein on 9/7/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "MazeLayer.h"
#import "Maze.h"
#import "Tile.h"

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

- (void)setupMazeTilesWithMaze:(Maze *)maze
{
   for (int row = 0; row < maze.mazeDimensions.rows; ++row)
   {
      for (int col = 0; col < maze.mazeDimensions.cols; ++col)
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
   for (NSMutableArray *tiles in maze.tiles)
   {
      for (Tile *tile in tiles)
      {
         if (tile.eastEdge && !tile.eastEdge.walkable)
         {
            CCSprite *eastEdgeSprite = [CCSprite spriteWithFile:@"edge_simple.png"];
            eastEdgeSprite.anchorPoint = ccp(.5, 1);
            eastEdgeSprite.position = ccp(tile.position.x*_tileSize.width,
                                          tile.position.y*_tileSize.height);
            [self addChild:eastEdgeSprite];
         }
         if (tile.northEdge && !tile.northEdge.walkable)
         {
            CCSprite *northEdgeSprite = [CCSprite spriteWithFile:@"edge_simple.png"];
            northEdgeSprite.rotation = 90;
            northEdgeSprite.anchorPoint = ccp(.5, 1);
            northEdgeSprite.position = ccp(tile.position.x*_tileSize.width,
                                           tile.position.y*_tileSize.height);
            [self addChild:northEdgeSprite];
         }
      }
   }
}

- (id)initWithMaze:(Maze *)maze
{
   if (self = [self init])
   {
      [self setupVariablesWithMaze:maze];
      [self setupMazeTilesWithMaze:maze];
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
