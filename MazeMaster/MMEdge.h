//
//  MMEdge.h
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMTile;

@interface MMEdge : NSObject

@property (readwrite, assign) MMTile* northTile;
@property (readwrite, assign) MMTile* eastTile;
@property (readwrite, assign) MMTile* southTile;
@property (readwrite, assign) MMTile* westTile;
@property (readwrite, assign) BOOL walkable;

@end
