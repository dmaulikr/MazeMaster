//
//  MMLevelFactory.h
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMLevel;
@interface MMLevelFactory : NSObject

+(id) levelFactory;
+(MMLevel *) levelForLevelNumber:(int)levelNumber;

@end
