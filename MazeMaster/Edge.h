//
//  Edge.h
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tile;

@interface Edge : NSObject
{
   Tile* _northTile;
   Tile* _eastTile;
   Tile* _southTile;
   Tile* _westTile;
}

@end
