//
//  MMVictim.m
//  MazeMaster
//
//  Created by Justin Fila on 12/18/13.
//  Copyright 2013 Binary Gods. All rights reserved.
//

#import "MMVictim.h"


@implementation MMVictim

- (id) initWithFile:(NSString *)filename
{
   if (self = [super initWithFile:filename])
   {
      //[self scheduleUpdate];
      //[self setupTextures];
   }
   return self;
}

- (void) attack
{
   NSLog(@"victim attack not implemented");
}

+ (MMVictim *)victimWithFile:(NSString *)filename
{
   // TODO: this is weird
   return (MMVictim *)[super characterWithFile:filename];
}

@end
