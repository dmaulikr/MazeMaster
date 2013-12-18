//
//  MMLevelSelectLayer.m
//  MazeMaster
//
//  Created by Gregory Klein on 8/13/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "MMLevelSelectLayer.h"
#import "MMLevelFactory.h"
#import "MMGameController.h"
#import "MMStartLayer.h"
#import "MMGameLayer.h"

@implementation MMLevelSelectLayer

- (void)addMainLabel:(NSString *)label
{
   CCLabelTTF *levelSelectLabel = [CCLabelTTF labelWithString:label
                                                     fontName:@"Helvetica"
                                                     fontSize:35];

   CGSize windowSize = [[CCDirector sharedDirector] winSize];
   levelSelectLabel.position = ccp(windowSize.width/2.0,
                                   windowSize.height - windowSize.height/9.0);
   
   [self addChild:levelSelectLabel];
}

- (void)addBackButton
{
   CCMenuItem *backButton = [CCMenuItemImage itemWithNormalImage:@"Arrow.png"
                                                   selectedImage:@"Arrow.png"];
   [backButton setBlock:^(id sender)
   {
      CCDirector *director = [CCDirector sharedDirector];
      [director replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5
                                                                    scene:[MMStartLayer scene]]];
   }];

   CGSize windowSize = [[CCDirector sharedDirector] winSize];
   backButton.position = ccp(30, windowSize.height - 30);
   backButton.scale = .25;
   backButton.rotation = 180;

   CCMenu *backButtonMenu = [CCMenu menuWithItems:backButton, nil];
   backButtonMenu.position = CGPointZero;

   [self addChild:backButtonMenu];
}

- (void)addLevelMenu
{
   CCLabelTTF *level1Label = [CCLabelTTF labelWithString:@"Level 1"
                                                fontName:@"Helvetica"
                                                fontSize:24];

   MMGameController *gameController = [MMGameController sharedController];
   CCMenuItem *level1Item = [CCMenuItemLabel itemWithLabel:level1Label
                                                     block:^(id sender)
   {
      [gameController setLevel:[MMLevelFactory levelForLevelNumber:1]];
      CCDirector *director = [CCDirector sharedDirector];
      CCScene *gameScene = [MMGameLayer scene];
      [director replaceScene:[CCTransitionFade transitionWithDuration:1.0
                                                             scene:gameScene]];
   }];

   CGSize windowSize = [[CCDirector sharedDirector] winSize];
   CGPoint firstMenuItemPosition = ccp(windowSize.width/2,
                                       windowSize.height/2 - windowSize.height/6);
   
   level1Item.position = firstMenuItemPosition;

   CCMenu *levelMenu = [CCMenu menuWithItems:level1Item, nil];
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
	MMLevelSelectLayer *layer = [MMLevelSelectLayer node];
	[scene addChild:layer];
   
	return scene;
}

@end
