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
   double yOffset = _subtileSize.width;
   for (int row = 0; row < SUBTILE_ROW_MAX; ++row)
   {
      for (int col = 0; col < SUBTILE_COL_MAX; ++col)
      {
         subtilePosition = ccp(col*_subtileSize.width + pos.x,
                               _windowSize.height - yOffset - row*_subtileSize.height - pos.y);
         [self drawTileWithOrigin:subtilePosition
                             size:_subtileSize];
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
         tilePosition = ccp(_leftPadding + col*_tileSize.width,
                            _windowSize.height - _topPadding - row*_tileSize.height);
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
         tilePosition = ccp(_leftPadding + col*_tileSize.width,
                            _windowSize.height - _topPadding - row*_tileSize.height);
         [self drawTileWithOrigin:tilePosition
                             size:_tileSize];
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
      _tileSize = CGSizeMake(_windowSize.height/4.0, _windowSize.height/4.0);
      _subtileSize = CGSizeMake(_tileSize.height/3.0, _tileSize.height/3.0);
      _topPadding = _tileSize.width;
      _leftPadding = 60;
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
   [self drawSubGridForRows:4 columns:5];
   [self drawGridWithRows:4 columns:5];
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
