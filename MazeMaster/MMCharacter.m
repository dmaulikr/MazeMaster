//
//  MMCharacter.m
//  MazeMaster
//
//  Created by Fila, Justin on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "MMCharacter.h"

@implementation MMCharacter

-(id) initWithFile:(NSString *)filename
{
   if (self = [super initWithFile:filename])
   {
      _velocity = CGPointZero;
      _direction = e_NONE;
   }
   return self;
}

-(void) attack
{
   NSLog(@"Character attack");
}

+(MMCharacter *) characterWithFile:(NSString *)filename;
{
   return [[[self alloc] initWithFile:filename] autorelease];
}

- (void)dealloc
{
   [super dealloc];
}

@end
