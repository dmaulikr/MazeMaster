//
//  SettingsLayer.m
//  MazeMaster
//
//  Created by Gregory Klein on 8/13/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "SettingsLayer.h"
#import "StartLayer.h"

@implementation SettingsLayer

- (void)addMainLabel:(NSString *)label
{
   CGSize windowSize = [[CCDirector sharedDirector] winSize];

   // create and initialize a Label
   CCLabelTTF *settingsLabel = [CCLabelTTF labelWithString:label
                                                  fontName:@"Marker Felt"
                                                  fontSize:35];

   // position the label on the center of the screen
   settingsLabel.position = ccp(windowSize.width/2.0,
                                windowSize.height - windowSize.height/9);

   // add the label as a child to this Layer
   [self addChild:settingsLabel];
}

- (void)addBackButton
{
   CGSize windowSize = [[CCDirector sharedDirector] winSize];
   
   CCLabelTTF *backButtonLabel = [CCLabelTTF labelWithString:@"<"
                                                    fontName:@"Marker Felt"
                                                    fontSize:40];
   CCMenuItem *backButtonItem = [CCMenuItemLabel itemWithLabel:backButtonLabel
                                                         block:^(id sender)
   {
      [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0
                                                                                   scene:[StartLayer scene]]];
   }];

   backButtonItem.position = ccp(30, windowSize.height - 30);
   CCMenu *backButtonMenu = [CCMenu menuWithItems:backButtonItem, nil];
   backButtonMenu.position = CGPointZero;
   
   [self addChild:backButtonMenu];
}

- (id)init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if (self = [super init])
   {
      [self addMainLabel:@"Settings"];
      [self addBackButton];
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
	SettingsLayer *layer = [SettingsLayer node];

	// add layer as a child to scene
	[scene addChild:layer];

	// return the scene
	return scene;
}

@end
