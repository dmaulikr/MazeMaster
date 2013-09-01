//
//  GameLayer.m
//  MazeMaster
//
//  Created by Gregory Klein on 8/6/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "GameLayer.h"
#import "GameController.h"
#import "Tile.h"
#import "LevelSelectLayer.h"
#import "PlayerLayer.h"
#import "ControlsLayer.h"

@implementation GameLayer

#define SUBTILE_ROW_MAX 3
#define SUBTILE_COL_MAX 3

- (void)addBackButton
{
   CGSize windowSize = [[CCDirector sharedDirector] winSize];

   CCMenuItem *backButton = [CCMenuItemImage itemWithNormalImage:@"Arrow.png"
                                                   selectedImage:@"Arrow.png"];
   [backButton setBlock:^(id sender)
   {
      CCDirector *director = [CCDirector sharedDirector];
      [director replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5
                                                                    scene:[LevelSelectLayer scene]]];
   }];

   backButton.scale = .25;
   backButton.rotation = 180;
   backButton.position = ccp(30, windowSize.height - 30);
   CCMenu *backButtonMenu = [CCMenu menuWithItems:backButton, nil];
   backButtonMenu.position = CGPointZero;

   [self addChild:backButtonMenu];
}

// used for testing, should be removed soon
- (void)setupDimensions
{
   _windowSize = [[CCDirector sharedDirector] winSize];
   _tileSize = CGSizeMake(102, 102);
   _subtileSize = CGSizeMake(20, 20);
   _topPadding = 50;
   _leftPadding = 90;

   _gameBounds = CGRectMake(0, 0, _tileSize.width*5, _tileSize.height*4);
   _gameBounds.origin.x = _leftPadding;
}

- (void)setupPlayer
{
//   CCSprite *player = [CCSprite spriteWithFile:@"astronaut_front.png"];
   _playerSprite = [Player playerWithFile:@"astronaut_front.png"];
   _playerSprite.position = ccp(_windowSize.width/4.0, _windowSize.height/4.0 + 5);
   _playerSprite.scale = 2;
   [self addChild:_playerSprite];
}

- (id)init
{
	if (self = [super init])
   {
      [self setupDimensions];
      [self setupMaze];
      [self setupPlayer];
      [self addBackButton];

      [self setTouchEnabled:YES];
      [self scheduleUpdate];
	}
	return self;
}

- (void)dealloc
{
   [super dealloc];
}

- (void)setupMaze
{
   NSLog(@"setting up maze for level %d: ", [[[GameController gameController] level] levelNumber]);
   for (int row = 0; row < 3; ++row)
   {
      for (int col = 0; col < 3; ++col)
      {
         CCSprite *tileSprite = [CCSprite spriteWithFile:@"gray_tile.png"];
         tileSprite.position = ccp(_leftPadding + col*_tileSize.width,
                                   _windowSize.height - _topPadding - row*_tileSize.height);
         [self addChild:tileSprite];
      }
   }
}

// called when player is done moving to a tile
-(void) finishedMovingPlayer:(id)sender
{
   [[GameController gameController] movePlayer];
}

// TODO: what if the player hits an enemy half way through a move?
-(void) movePlayerByX:(int)x andY:(int)y
{
   CGPoint newPoint = CGPointMake(_playerSprite.position.x + x, _playerSprite.position.y + y);
   CCMoveTo *moveAction = [CCMoveTo actionWithDuration:.6f position:newPoint];
   
   CCCallFunc *actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(finishedMovingPlayer:)];

   CCSequence *actionSequence = [CCSequence actions:moveAction, actionMoveDone, nil];
   [_playerSprite runAction:actionSequence];
}

// Helper class method that creates a Scene with the StartLayer as the only child.
+ (CCScene *)scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];

	// 'layer' is an autorelease object.
	GameLayer *gameLayer = [GameLayer node];
   // TODO: get the tag to work, currently does nothing. Then we could take
   // the gameLayer out of the controlsLayer class
   gameLayer.tag = 1;
   // currently needed to access the game layer
   [GameController gameController].gameLayer = gameLayer;
   
   ControlsLayer *controlsLayer = [ControlsLayer node];

	// add layer as a child to scene
	[scene addChild:gameLayer];
	[scene addChild:controlsLayer];
   
	// return the scene
	return scene;
}

@end
