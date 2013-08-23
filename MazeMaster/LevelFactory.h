//
//  LevelFactory.h
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Level;
@interface LevelFactory : NSObject
{
}

+(id) levelFactory;
+(Level *) levelForLevelNumber:(int)levelNumber;

@end
