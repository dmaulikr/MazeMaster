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
}

- (Tile *)getAdjacentTileForDirection:(PlayerDirection)direction;
- (Edge *)getAdjacentEdgeForDirection:(PlayerDirection)direction;
- (CCArray *)walkableNeighborTiles;

@property (readwrite, assign) CGPoint position;
@property (readwrite, assign) Edge* northEdge;
@property (readwrite, assign) Edge* eastEdge;
@property (readwrite, assign) Edge* southEdge;
@property (readwrite, assign) Edge* westEdge;
@property (readwrite, retain) CCSprite *tileSprite;

// used for A* pathfinding
@property (readwrite, retain) Tile *parent;
@property (readwrite, assign) int cost;
@property (readwrite, assign) int heuristic;
@property (readwrite, assign) int genID;
@property (readonly) int optimality;

@end
