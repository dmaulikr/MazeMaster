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
                                                     fontName:@"Marker Felt"
                                                     fontSize:35];

   levelSelectLabel.position = ccp(windowSize.width/2.0,
                                   windowSize.height - windowSize.height/9.0);
   
   [self addChild:levelSelectLabel];
}

- (void)addBackButton
{
   CCLabelTTF *backButtonLabel = [CCLabelTTF labelWithString:@"<"
                                                    fontName:@"Marker Felt"
                                                    fontSize:40];
   
   CCMenuItem *backButtonItem = [CCMenuItemLabel itemWithLabel:backButtonLabel
                                                         block:^(id sender)
   {
      CCDirector *director = [CCDirector sharedDirector];
      CCScene *startScene = [StartLayer scene];
      [director replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5
                                                                    scene:startScene]];
   }];

   backButtonItem.position = ccp(30, [[CCDirector sharedDirector] winSize].height - 30);
   CCMenu *backButtonMenu = [CCMenu menuWithItems:backButtonItem, nil];
   backButtonMenu.position = CGPointZero;
   
   [self addChild:backButtonMenu];
}

- (void)addLevelMenu
{
   CGSize windowSize = [[CCDirector sharedDirector] winSize];
   CCLabelTTF *level1Label = [CCLabelTTF labelWithString:@"Level 1"
                                                fontName:@"Marker Felt"
                                                fontSize:24];
   CCLabelTTF *level2Label = [CCLabelTTF labelWithString:@"Level 2"
                                                fontName:@"Marker Felt"
                                                fontSize:24];
   CCLabelTTF *level3Label = [CCLabelTTF labelWithString:@"Level 3"
                                                fontName:@"Marker Felt"
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
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
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
