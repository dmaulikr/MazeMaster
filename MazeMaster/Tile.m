//
//  Tile.m
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "Tile.h"
#import "Edge.h"

@implementation Tile

-(id) initWithNorth:(BOOL)northEdge
           withEast:(BOOL)eastEdge
          withSouth:(BOOL)southEdge
           withWest:(BOOL)westEdge
{
   if ( self = [super init] )
   {
      if ( northEdge )
         _northEdge = [[Edge alloc] init];
         
      if ( eastEdge )
         _eastEdge = [[Edge alloc] init];
      
      if ( southEdge )
         _southEdge = [[Edge alloc] init];
      
      if ( westEdge )
         _westEdge = [[Edge alloc] init];
   }
   return self;
}

-(void) dealloc
{
   [super dealloc];
   
   [_northEdge release];
   [_eastEdge release];
   [_southEdge release];
   [_westEdge release];
}

@end
