//
//  MMMazeLayer.m
//  MazeMaster
//
//  Created by Gregory Klein on 9/7/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "MMMazeLayer.h"
#import "MMMaze.h"
#import "MMTile.h"

@interface MMMazeLayer()
{
   CGSize _windowSize;
   CGSize _tileSize;

   float _topPadding;
   float _leftPadding;
}
@end

@implementation MMMazeLayer

- (id)init
{
   if (self = [super init])
   {
      _windowSize = [[CCDirector sharedDirector] winSize];
      _tileSize = CGSizeMake(44, 44);
   }
   return self;
}

- (void)setupVariablesWithMaze:(MMMaze *)maze
{
   _mazeSize.width = _tileSize.width*maze.mazeDimensions.cols;
   _mazeSize.height = _tileSize.height*maze.mazeDimensions.rows;
}

- (void)addTileSpriteWithFilename:(NSString *)filename
                          forTile:(MMTile *)tile
{
   CCSprite *tileSprite = [CCSprite spriteWithFile:filename];
   tile.tileSprite = tileSprite;
   
   tileSprite.anchorPoint = CGPointZero;
   tileSprite.position = ccp((tile.position.x-1)*_tileSize.width,
                             (tile.position.y-1)*_tileSize.height);
   [self addChild:tileSprite];
}

- (void)setupMazeTilesWithMaze:(MMMaze *)maze
{
   for (NSMutableArray *tiles in maze.tiles)
      for (MMTile *tile in tiles)
         [self addTileSpriteWithFilename:@"blue_tile.png"
                                 forTile:tile];
}

- (void)setupMazeEdgesWithMaze:(MMMaze *)maze
{
   for (NSMutableArray *tiles in maze.tiles)
      for (MMTile *tile in tiles)
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

- (id)initWithMaze:(MMMaze *)maze
{
   if (self = [self init])
   {
      [self setupVariablesWithMaze:maze];
      [self setupMazeTilesWithMaze:maze];
      [self setupMazeEdgesWithMaze:maze];
   }
   return self;
}

+ (CCScene *)scene
{
	CCScene *scene = [CCScene node];
	MMMazeLayer *mazeLayer = [MMMazeLayer node];
   [scene addChild:mazeLayer];
	return scene;
}

@end
