//
//  LevelSelectLayer.m
//  MazeMaster
//
//  Created by Gregory Klein on 8/13/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "LevelSelectLayer.h"
#import "StartLayer.h"
#import "GameLayer.h"

@implementation LevelSelectLayer

- (void)addMainLabel:(NSString *)label
{
   // ask director for the window size
   CGSize windowSize = [[CCDirector sharedDirector] winSize];

   // create and initialize a Label
   CCLabelTTF *levelSelectLabel = [CCLabelTTF labelWithString:label
                                                     fontName:@"Marker Felt"
                                                     fontSize:35];

   // position the label on the center of the screen
   levelSelectLabel.position = ccp(windowSize.width/2.0,
                                   windowSize.height - windowSize.height/9.0);

   // add the label as a child to this Layer
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

   [level1Label setHorizontalAlignment:kCCTextAlignmentLeft];

   CCMenuItem *level1Item = [CCMenuItemLabel itemWithLabel:level1Label
                                                     block:^(id sender)
    {
       CCDirector *director = [CCDirector sharedDirector];
       CCScene *gameScene = [GameLayer scene];
       [director replaceScene:[CCTransitionFade transitionWithDuration:1.0
                                                                scene:gameScene]];
    }];

   CGPoint firstMenuItemPosition = ccp(windowSize.width/2,
                                       windowSize.height/2 - windowSize.height/6);

   level1Item.position = firstMenuItemPosition;
   CCMenu *levelMenu = [CCMenu menuWithItems:level1Item, nil];
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

// Helper class method that creates a Scene with the StartLayer as the only child.
+ (CCScene *)scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];

	// 'layer' is an autorelease object.
	LevelSelectLayer *layer = [LevelSelectLayer node];

	// add layer as a child to scene
	[scene addChild:layer];

	// return the scene
	return scene;
}

@end
