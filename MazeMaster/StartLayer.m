//
//  StartLayer.m
//  MazeMaster
//
//  Created by Gregory Klein on 8/4/13.
//  Copyright Binary Gods 2013. All rights reserved.
//

// Import the interfaces
#import "StartLayer.h"
#import "LevelSelectLayer.h"
#import "SettingsLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - StartLayer

// StartLayer implementation
@implementation StartLayer

// Helper class method that creates a Scene with the StartLayer as the only child.
+ (CCScene *)scene
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

- (void)addMainLabel:(NSString *)label
{
   // ask director for the window size
   CGSize windowSize = [[CCDirector sharedDirector] winSize];

   // create and initialize a Label
   CCLabelTTF *mainlabel = [CCLabelTTF labelWithString:label
                                              fontName:@"Marker Felt"
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
                                             fontName:@"Marker Felt"
                                             fontSize:64];

		// position the label on the center of the screen
		mainlabel.position = ccp(windowSize.width/2,
                               windowSize.height - windowSize.height/4);

		// add the label as a child to this Layer
		[self addChild: mainlabel];
      
      CCLabelTTF *levelSelectLabel = [CCLabelTTF labelWithString:@"Select Level"
                                                        fontName:@"Marker Felt"
                                                        fontSize:24];
      
      CCLabelTTF *settingsLabel = [CCLabelTTF labelWithString:@"Settings"
                                                     fontName:@"Marker Felt"
                                                     fontSize:24];

      // We're using CCMenuItemFont* objects for the menu items because you can actually set the
      // anchor point on those, as opposed to CCMenuItemLabel* objects -- by resetting the anchor
      // point on these guys to (0,0), we can easily left-align them
      CCMenuItemFont *levelSelectItem = [CCMenuItemFont itemWithLabel:levelSelectLabel
                                                             block:^(id sender)
      {
         [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0
                                                                                      scene:[LevelSelectLayer scene]]];
      }];

      CCMenuItemFont *settingsItem = [CCMenuItemFont itemWithLabel:settingsLabel
                                                             block:^(id sender)
      {
         [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0
                                                                                      scene:[SettingsLayer scene]]];
      }];

      static int padding = 10;
      CGPoint firstMenuItemPosition = ccp(mainlabel.boundingBox.origin.x,
                                          windowSize.height/2 - windowSize.height/6);

      [levelSelectItem setAnchorPoint:ccp(0,0)];
      [settingsItem setAnchorPoint:ccp(0,0)];
      
      levelSelectItem.position = firstMenuItemPosition;
      settingsItem.position = ccp(firstMenuItemPosition.x,
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
