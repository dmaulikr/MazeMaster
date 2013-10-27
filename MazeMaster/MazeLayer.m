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

@interface MazeLayer()
{
   CGSize _windowSize;
   CGSize _tileSize;

   float _topPadding;
   float _leftPadding;
}
@end

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

- (void)addTileSpriteWithFilename:(NSString *)filename
                          forTile:(Tile *)tile
{
   CCSprite *tileSprite = [CCSprite spriteWithFile:filename];
   tile.tileSprite = tileSprite;
   
   tileSprite.anchorPoint = CGPointZero;
   tileSprite.position = ccp((tile.position.x-1)*_tileSize.width,
                             (tile.position.y-1)*_tileSize.height);
   [self addChild:tileSprite];
}

- (void)setupMazeTilesWithMaze:(Maze *)maze
{
   for (NSMutableArray *tiles in maze.tiles)
      for (Tile *tile in tiles)
         [self addTileSpriteWithFilename:@"blue_tile.png"
                                 forTile:tile];
}

- (void)setupMazeEdgesWithMaze:(Maze *)maze
{
   for (NSMutableArray *tiles in maze.tiles)
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
