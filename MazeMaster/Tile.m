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

-(id) init
{
   if ( self = [super init] )
   {
      // initialize stuff
   }
   return self;
}

-(void) dealloc
{
   if ( _northEdge )
      [_northEdge release];
   
   if ( _eastEdge )
      [_eastEdge release];
   
   if ( _southEdge )
      [_southEdge release];
   
   if ( _westEdge )
      [_westEdge release];
   
   [super dealloc];
}

@end
