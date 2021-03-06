//
//  MMIntroLayer.m
//  MazeMaster
//
//  Created by Gregory Klein on 8/4/13.
//  Copyright Binary Gods 2013. All rights reserved.
//


// Import the interfaces
#import "MMIntroLayer.h"
#import "MMStartLayer.h"

#pragma mark - MMIntroLayer

// StartLayer implementation
@implementation MMIntroLayer

// Helper class method that creates a Scene with the StartLayer as the only child.
+ (CCScene *)scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MMIntroLayer *layer = [MMIntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id)init
{
	if(self = [super init])
   {
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];

		CCSprite *background;
		
		if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
      {
			background = [CCSprite spriteWithFile:@"Default.png"];
			background.rotation = 90;
		}
      else
      {
			background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
		}
		background.position = ccp(size.width/2, size.height/2);

		// add the label as a child to this Layer
		[self addChild: background];
	}
	return self;
}

- (void)onEnter
{
	[super onEnter];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0
                                                                                scene:[MMStartLayer scene] ]];
}
@end
