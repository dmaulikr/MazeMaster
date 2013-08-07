//
//  HelloWorldLayer.m
//  MazeMaster
//
//  Created by Gregory Klein on 8/4/13.
//  Copyright Binary Gods 2013. All rights reserved.
//


// Import the interfaces
#import "StartLayer.h"
#import "GameLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation StartLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];

	// 'layer' is an autorelease object.
	StartLayer *layer = [StartLayer node];

	// add layer as a child to scene
	[scene addChild: layer];

	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if (self = [super init])
   {
      // ask director for the window size
//      CGSize size = [[CCDirector sharedDirector] winSize];
//      
//      CCSprite *rightArrow = [CCSprite spriteWithFile:@"Arrow.png"];
//      CCSprite *leftArrow = [CCSprite spriteWithFile:@"Arrow.png"];
//
//      leftArrow.flipX = YES;
//      [leftArrow setAnchorPoint:CGPointMake(0,0)];
//      leftArrow.position = ccp(0, 0);
//
//      [rightArrow setAnchorPoint:CGPointMake(1,0)];
//      rightArrow.position = ccp(size.width, 0);
//
//      [self addChild:rightArrow];
//      [self addChild:leftArrow];

		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Maze Master"
                                             fontName:@"Marker Felt"
                                             fontSize:64];

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];

		// position the label on the center of the screen
		label.position =  ccp(size.width/2,
                            size.height - size.height/4);

		// add the label as a child to this Layer
		[self addChild: label];

      CCMenuItem *playItem = [CCMenuItemImage itemWithNormalImage:@"Arrow.png"
                                                    selectedImage:@"Arrow.png"
                                                            block:^(id sender) {
         NSLog(@"play button selected");

         [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0
                                                                                      scene:[GameLayer scene] ]];
      }];

      playItem.position = ccp(size.width/2,
                              size.height/2 - size.height/6);

      CCMenu *startMenu = [CCMenu menuWithItems:playItem, nil];
      startMenu.position = CGPointZero;

      [self addChild:startMenu];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)

	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
