//
//  GameLayer.m
//  MazeMaster
//
//  Created by Gregory Klein on 8/6/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "GameLayer.h"
#import "LevelSelectLayer.h"

@implementation GameLayer

#define TILE_SIZE CGSizeMake(60,60)
#define SUBTILE_SIZE CGSizeMake(20,20)
#define LEFT_PADDING 60
#define TOP_PADDING 70
#define SUBTILE_ROW_MAX 3
#define SUBTILE_COL_MAX 3

- (void)addBackButton
{
   CCLabelTTF *backButtonLabel = [CCLabelTTF labelWithString:@"<"
                                                    fontName:@"Marker Felt"
                                                    fontSize:40];
   CCMenuItem *backButtonItem = [CCMenuItemLabel itemWithLabel:backButtonLabel
                                                         block:^(id sender)
   {
      CCDirector *director = [CCDirector sharedDirector];
      CCScene *levelSelectScene = [LevelSelectLayer scene];
      [director replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5
                                                                    scene:levelSelectScene]];
   }];

   backButtonItem.position = ccp(30, _windowSize.height - 30);
   CCMenu *backButtonMenu = [CCMenu menuWithItems:backButtonItem, nil];
   backButtonMenu.position = CGPointZero;
   
   [self addChild:backButtonMenu];
}

- (void)setupDrawingForMainGrid
{
   ccDrawColor4F(1.0f, 1.0f, 1.0f, 0.6f);
   ccPointSize(16);
}

- (void)setupDrawingForSubGrid
{
   ccDrawColor4F(1.0f, 100/255.0f, 100/255.0f, 0.2f);
   ccPointSize(10);
}

- (void)drawTileWithOrigin:(CGPoint)origin size:(CGSize)size
{
   ccDrawRect(origin, ccp(origin.x + size.width,
                          origin.y + size.height));
}

- (void)drawSubtilesInTileAtPosition:(CGPoint)pos
{
   CGPoint subtilePosition;
   static int yOffset = 20;
   for (int row = 0; row < SUBTILE_ROW_MAX; ++row)
   {
      for (int col = 0; col < SUBTILE_COL_MAX; ++col)
      {
         subtilePosition = ccp(col*SUBTILE_SIZE.width + pos.x,
                               _windowSize.height - yOffset - row*SUBTILE_SIZE.height - pos.y);
         [self drawTileWithOrigin:subtilePosition
                             size:SUBTILE_SIZE];
      }
   }
}

- (void)drawSubGridForRows:(int)rows columns:(int)cols
{
   [self setupDrawingForSubGrid];
   CGPoint tilePosition;
   for (int row = 0; row < rows; ++row)
   {
      for (int col = 0; col < cols; ++col)
      {
         tilePosition = ccp(LEFT_PADDING + col*TILE_SIZE.width,
                            _windowSize.height - TOP_PADDING - row*TILE_SIZE.height);
         [self drawSubtilesInTileAtPosition:tilePosition];
      }
   }
}

- (void)drawGridWithRows:(int)rows columns:(int)cols
{
   [self setupDrawingForMainGrid];
   CGPoint tilePosition;
   for (int row = 0; row < rows; ++row)
   {
      for (int col = 0; col < cols; ++col)
      {
         tilePosition = ccp(LEFT_PADDING + col*TILE_SIZE.width,
                            _windowSize.height - TOP_PADDING - row*TILE_SIZE.height);
         [self drawTileWithOrigin:tilePosition
                             size:TILE_SIZE];
      }
   }
}

- (id)init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if (self = [super init])
   {
      _windowSize = [[CCDirector sharedDirector] winSize];
      [self addBackButton];
	}
	return self;
}

- (void)dealloc
{
   [super dealloc];
}

- (void)draw
{
   [self drawSubGridForRows:5 columns:6];
   [self drawGridWithRows:5 columns:6];
}

// Helper class method that creates a Scene with the StartLayer as the only child.
+ (CCScene *)scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];

	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];

	// add layer as a child to scene
	[scene addChild:layer];

	// return the scene
	return scene;
}

@end
