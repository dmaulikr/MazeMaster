//
//  Player.m
//  MazeMaster
//
//  Created by Justin Fila on 8/19/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "Player.h"

@implementation Player

-(id)initWithFile:(NSString *)filename
{
   if (self = [super initWithFile:filename])
   {
      // stuff
   }
   return self;
}

-(void) attack
{
   NSLog(@"Player attack");
}

+(Player *) playerWithFile:(NSString *)filename
{
   // TODO: this is weird
   return (Player *)[super characterWithFile:filename];
}

- (void)dealloc
{
   [super dealloc];
}

@end
