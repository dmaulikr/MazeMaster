//
//  MMEnemy.m
//  MazeMaster
//
//  Created by Fila, Justin on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "MMEnemy.h"

@implementation MMEnemy

-(id)initWithFile:(NSString *)filename
{
   if (self = [super initWithFile:filename])
   {
      _currentTile = nil;
   }
   return self;
}

-(void) attack
{
   NSLog(@"Enemy attack");
}

+(MMEnemy *) enemyWithFile:(NSString *)filename
{
   // TODO: this is weird
   return (MMEnemy *)[super characterWithFile:filename];
}

- (void)dealloc
{
   [super dealloc];
}

@end
