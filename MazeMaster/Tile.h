//
//  Tile.h
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Edge.h"

@interface Tile : NSObject
{
   Edge* _northEdge;
   Edge* _eastEdge;
   Edge* _southEdge;
   Edge* _westEdge;
}

@end
