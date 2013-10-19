//
//  MMCharacter.h
//  MazeMaster
//
//  Created by Fila, Justin on 10/18/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "CCSprite.h"

@interface MMCharacter : CCSprite
{
}

@property (readwrite, assign) CGPoint velocity;
@property (readwrite, assign) CGPoint absolutePosition;

-(id) initWithFile:(NSString *)filename;
-(void) attack;
+(MMCharacter *) characterWithFile:(NSString *)filename;

@end
