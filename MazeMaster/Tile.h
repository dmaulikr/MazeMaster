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

- (Tile *)getAdjacentTileForDirection:(CharacterDirection)direction;
- (Edge *)getAdjacentEdgeForDirection:(CharacterDirection)direction;
- (CCArray *)walkableNeighborTiles;

@property (readwrite, assign) CGPoint position;
@property (readwrite, assign) Edge* northEdge;
@property (readwrite, assign) Edge* eastEdge;
@property (readwrite, assign) Edge* southEdge;
@property (readwrite, assign) Edge* westEdge;
@property (readwrite, retain) CCSprite *tileSprite;
@property (readwrite, assign) BOOL isActive;
@property (readwrite, assign) BOOL willBeActive;

// used for A* pathfinding
@property (readwrite, retain) NSString *travelerKey;
@property (readwrite, retain) Tile *parent;
@property (readonly, nonatomic) CharacterDirection directionFromParent;
@property (readonly, nonatomic) CharacterDirection directionToParent;
@property (readwrite, assign) int cost;
@property (readwrite, assign) float heuristic;
@property (readonly) float optimality;

@end
