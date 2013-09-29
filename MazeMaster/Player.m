//
//  Player.m
//  MazeMaster
//
//  Created by Justin Fila on 8/19/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "Player.h"

@implementation Player

@synthesize playerVelocity = _playerVelocity;
@synthesize absolutePosition = _absolutePosition;

-(id)initWithFile:(NSString *)filename
{
   if (self == [super initWithFile:filename])
   {
      _playerVelocity = CGPointZero;
   }
   return self;
}

+(Player *) playerWithFile:(NSString *)filename
{
//   return [CCSprite spriteWithFile:filename];
   return [[[self alloc] initWithFile:filename] autorelease];
}

- (void)dealloc
{
   [super dealloc];
}

@end
