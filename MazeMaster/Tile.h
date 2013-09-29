//
//  Tile.h
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Edge.h"
#import "PlayerTypedefs.h"

@interface Tile : NSObject
{
   Edge* _northEdge;
   Edge* _eastEdge;
   Edge* _southEdge;
   Edge* _westEdge;
   CGPoint _position;
}

- (Tile *)getAdjacentTileForDirection:(PlayerDirection)direction;
- (Edge *)getAdjacentEdgeForDirection:(PlayerDirection)direction;

@property (readwrite, assign) Edge* northEdge;
@property (readwrite, assign) Edge* eastEdge;
@property (readwrite, assign) Edge* southEdge;
@property (readwrite, assign) Edge* westEdge;
@property (readwrite, assign) CGPoint position;

@end
