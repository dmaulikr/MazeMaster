//
//  MMTile.h
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMEdge.h"
#import "MMPlayerTypedefs.h"

@interface MMTile : NSObject

- (MMTile *)getAdjacentTileForDirection:(CharacterDirection)direction;
- (MMEdge *)getAdjacentEdgeForDirection:(CharacterDirection)direction;
- (CCArray *)walkableNeighborTiles;

@property (readwrite, assign) CGPoint position;
@property (readwrite, assign) MMEdge* northEdge;
@property (readwrite, assign) MMEdge* eastEdge;
@property (readwrite, assign) MMEdge* southEdge;
@property (readwrite, assign) MMEdge* westEdge;
@property (readwrite, retain) CCSprite *tileSprite;
@property (readwrite, assign) BOOL isActive;
@property (readwrite, assign) BOOL willBeActive;

// used for A* pathfinding
@property (readwrite, retain) NSString *travelerKey;
@property (readwrite, retain) MMTile *parent;
@property (readonly, nonatomic) CharacterDirection directionFromParent;
@property (readonly, nonatomic) CharacterDirection directionToParent;
@property (readwrite, assign) int cost;
@property (readwrite, assign) float heuristic;
@property (readonly) float optimality;

@end
