//
//  MazeLayer.m
//  MazeMaster
//
//  Created by Gregory Klein on 9/7/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "MazeLayer.h"

@implementation MazeLayer

@synthesize mazeSize = _mazeSize;

- (id)init
{
   if (self = [super init]) {
   }
   return self;
}

- (id)initWithRows:(int)rows
           columns:(int)cols
{
   if (self = [super init])
   {
      _windowSize = [[CCDirector sharedDirector] winSize];
      _tileSize = CGSizeMake(102, 102);
      _mazeSize.width = _tileSize.width*cols + 10;
      _mazeSize.height = _tileSize.height*rows + 10;
      for (int row = 0; row < rows; ++row)
      {
         for (int col = 0; col < cols; ++col)
         {
            CCSprite *tileSprite = [CCSprite spriteWithFile:@"gray_tile.png"];
            tileSprite.anchorPoint = CGPointZero;
            tileSprite.position = ccp(col*_tileSize.width,
                                      row*_tileSize.height);
            [self addChild:tileSprite];
         }
      }
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
