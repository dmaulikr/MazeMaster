//
//  MMStartLayer.m
//  MazeMaster
//
//  Created by Gregory Klein on 8/4/13.
//  Copyright Binary Gods 2013. All rights reserved.
//

// Import the interfaces
#import "MMStartLayer.h"
#import "MMLevelSelectLayer.h"
#import "MMSettingsLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - MMStartLayer

// StartLayer implementation
@implementation MMStartLayer

// Helper class method that creates a Scene with the StartLayer as the only child.
+ (CCScene *)scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];

	// 'layer' is an autorelease object.
	MMStartLayer *layer = [MMStartLayer node];

	// add layer as a child to scene
	[scene addChild: layer];

	// return the scene
	return scene;
}

- (void)addMainLabel:(NSString *)label
{
   // ask director for the window size
   CGSize windowSize = [[CCDirector sharedDirector] winSize];

   // create and initialize a Label
   CCLabelTTF *mainlabel = [CCLabelTTF labelWithString:label
                                              fontName:@"Helvetica"
                                              fontSize:64];

   // position the label on the center of the screen
   mainlabel.position = ccp(windowSize.width/2,
                            windowSize.height - windowSize.height/4);

   // add the label as a child to this Layer
   [self addChild: mainlabel];
}

// on "init" you need to initialize your instance
- (id)init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if (self = [super init])
   {
		// ask director for the window size
		CGSize windowSize = [[CCDirector sharedDirector] winSize];

		// create and initialize a Label
		CCLabelTTF *mainlabel = [CCLabelTTF labelWithString:@"Maze Master"
                                             fontName:@"Helvetica"
                                             fontSize:64];

		// position the label on the center of the screen
		mainlabel.position = ccp(windowSize.width/2,
                               windowSize.height - windowSize.height/4);

		// add the label as a child to this Layer
		[self addChild: mainlabel];
      
      CCLabelTTF *levelSelectLabel = [CCLabelTTF labelWithString:@"Select Level"
                                                        fontName:@"Helvetica"
                                                        fontSize:24];
      
      CCLabelTTF *settingsLabel = [CCLabelTTF labelWithString:@"Settings"
                                                     fontName:@"Helvetica"
                                                     fontSize:24];

      // DESIGN DECISION: should touch state for each item animate the label up and centered, or
      // up and to the right??? The type of object we use here for each label depends on the answer
      // to that question -- if we want to animate up and to the right, then we need to use a
      // CCMenuItemFont so we can adjust the anchor point which will have an effect on the animation
      // -- that would also make the left-alignment a little more simple
      CCMenuItem *levelSelectItem = [CCMenuItemLabel itemWithLabel:levelSelectLabel
                                                             block:^(id sender)
      {
         CCDirector *director = [CCDirector sharedDirector];
         CCScene *levelSelectScene = [MMLevelSelectLayer scene];
         [director replaceScene:[CCTransitionFade transitionWithDuration:1.0
                                                                   scene:levelSelectScene]];
      }];

      CCMenuItem *settingsItem = [CCMenuItemLabel itemWithLabel:settingsLabel
                                                             block:^(id sender)
      {
         CCDirector *director = [CCDirector sharedDirector];
         CCScene *settingsScene = [MMSettingsLayer scene];
         [director replaceScene:[CCTransitionFade transitionWithDuration:1.0
                                                                   scene:settingsScene]];
      }];

      static int padding = 10;
      CGPoint firstMenuItemPosition = ccp(mainlabel.boundingBox.origin.x, //- mainlabel.boundingBox.size.width/2.0,
                                          windowSize.height/2 - windowSize.height/6);

      levelSelectItem.position = ccp(firstMenuItemPosition.x + levelSelectLabel.boundingBox.size.width/2.0,
                                      firstMenuItemPosition.y);
      settingsItem.position = ccp(firstMenuItemPosition.x + settingsItem.boundingBox.size.width/2.0,
                                  firstMenuItemPosition.y - (levelSelectLabel.boundingBox.size.height + padding));

      CCMenu *startMenu = [CCMenu menuWithItems:levelSelectItem, settingsItem, nil];
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
	AppController *app = (AppController *) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController *) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
