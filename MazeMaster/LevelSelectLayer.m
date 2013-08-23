//
//  LevelSelectLayer.m
//  MazeMaster
//
//  Created by Gregory Klein on 8/13/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "LevelSelectLayer.h"
#import "LevelFactory.h"
#import "GameController.h"
#import "StartLayer.h"
#import "GameLayer.h"

@implementation LevelSelectLayer

- (void)addMainLabel:(NSString *)label
{
   CGSize windowSize = [[CCDirector sharedDirector] winSize];

   CCLabelTTF *levelSelectLabel = [CCLabelTTF labelWithString:label
                                                     fontName:@"Helvetica"
                                                     fontSize:35];

   levelSelectLabel.position = ccp(windowSize.width/2.0,
                                   windowSize.height - windowSize.height/9.0);
   
   [self addChild:levelSelectLabel];
}

- (void)addBackButton
{
   CGSize windowSize = [[CCDirector sharedDirector] winSize];

   CCMenuItem *backButton = [CCMenuItemImage itemWithNormalImage:@"Arrow.png"
                                                   selectedImage:@"Arrow.png"];

   [backButton setBlock:^(id sender) {
      CCDirector *director = [CCDirector sharedDirector];
      [director replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5
                                                                    scene:[StartLayer scene]]];
   }];

   backButton.scale = .25;
   backButton.rotation = 180;
   backButton.position = ccp(30, windowSize.height - 30);
   CCMenu *backButtonMenu = [CCMenu menuWithItems:backButton, nil];
   backButtonMenu.position = CGPointZero;

   [self addChild:backButtonMenu];
}

- (void)addLevelMenu
{
   CGSize windowSize = [[CCDirector sharedDirector] winSize];
   CCLabelTTF *level1Label = [CCLabelTTF labelWithString:@"Level 1"
                                                fontName:@"Helvetica"
                                                fontSize:24];
   CCLabelTTF *level2Label = [CCLabelTTF labelWithString:@"Level 2"
                                                fontName:@"Helvetica"
                                                fontSize:24];
   CCLabelTTF *level3Label = [CCLabelTTF labelWithString:@"Level 3"
                                                fontName:@"Helvetica"
                                                fontSize:24];

   [level1Label setHorizontalAlignment:kCCTextAlignmentLeft];
   [level2Label setHorizontalAlignment:kCCTextAlignmentLeft];
   [level3Label setHorizontalAlignment:kCCTextAlignmentLeft];

   GameController *gameController = [GameController gameController];
   CCMenuItem *level1Item = [CCMenuItemLabel itemWithLabel:level1Label
                                                     block:^(id sender)
                              {
                                 [gameController setLevel:[LevelFactory levelForLevelNumber:1]];
                                 CCDirector *director = [CCDirector sharedDirector];
                                 CCScene *gameScene = [GameLayer scene];
                                 [director replaceScene:[CCTransitionFade transitionWithDuration:1.0
                                                                                        scene:gameScene]];
                              }];

   CCMenuItem *level2Item = [CCMenuItemLabel itemWithLabel:level2Label
                                                     block:^(id sender)
                              {
                                 [gameController setLevel:[LevelFactory levelForLevelNumber:2]];
                                 CCDirector *director = [CCDirector sharedDirector];
                                 CCScene *gameScene = [GameLayer scene];
                                 [director replaceScene:[CCTransitionFade transitionWithDuration:1.0
                                                                                          scene:gameScene]];
                              }];

   CCMenuItem *level3Item = [CCMenuItemLabel itemWithLabel:level3Label
                                                     block:^(id sender)
                              {
                                 [gameController setLevel:[LevelFactory levelForLevelNumber:3]];
                                 CCDirector *director = [CCDirector sharedDirector];
                                 CCScene *gameScene = [GameLayer scene];
                                 [director replaceScene:[CCTransitionFade transitionWithDuration:1.0
                                                                                           scene:gameScene]];
                              }];

   CGPoint firstMenuItemPosition = ccp(windowSize.width/2,
                                       windowSize.height/2 - windowSize.height/6);

   int padding = 5;
   level1Item.position = firstMenuItemPosition;
   level2Item.position = ccp(firstMenuItemPosition.x,
                             firstMenuItemPosition.y - level2Item.boundingBox.size.height - padding);
   level3Item.position = ccp(firstMenuItemPosition.x,
                             firstMenuItemPosition.y - (level2Item.boundingBox.size.height + padding)*2);

   CCMenu *levelMenu = [CCMenu menuWithItems:level1Item, level2Item, level3Item, nil];
   levelMenu.position = CGPointZero;

   [self addChild:levelMenu];
}

- (id)init
{
	if (self = [super init])
   {
      [self addMainLabel:@"Select Level"];
      [self addBackButton];
      [self addLevelMenu];
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
	LevelSelectLayer *layer = [LevelSelectLayer node];
	[scene addChild:layer];
   
	return scene;
}

@end
