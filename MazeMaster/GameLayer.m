//
//  GameLayer.m
//  MazeMaster
//
//  Created by Gregory Klein on 8/6/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "GameLayer.h"


@implementation GameLayer

- (id)init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if (self = [super init])
   {
      // ask director for the window size
      CGSize size = [[CCDirector sharedDirector] winSize];

      CCSprite *rightArrow = [CCSprite spriteWithFile:@"Arrow.png"];
      CCSprite *leftArrow = [CCSprite spriteWithFile:@"Arrow.png"];

      leftArrow.flipX = YES;
      [leftArrow setAnchorPoint:CGPointMake(0,0)];
      leftArrow.position = ccp(0, 0);

      [rightArrow setAnchorPoint:CGPointMake(1,0)];
      rightArrow.position = ccp(size.width, 0);

      [self addChild:rightArrow];
      [self addChild:leftArrow];
	}
	return self;
}

- (void)dealloc
{
   [super dealloc];
}

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];

	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];

	// add layer as a child to scene
	[scene addChild: layer];

	// return the scene
	return scene;
}

@end
