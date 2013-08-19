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

@synthesize northEdge = _northEdge;
@synthesize eastEdge = _eastEdge;
@synthesize southEdge = _southEdge;
@synthesize westEdge = _westEdge;

-(id) init
{
   if ( self = [super init] )
   {
      // initialize stuff
   }
   return self;
}

-(NSString *) description
{
   NSString *string = [[NSString alloc] initWithFormat:
                       @"Tile: %p\n     northEdge %p\n     eastEdge %p\n     southEdge %p\n     westEdge %p",
                       self, _northEdge, _eastEdge, _southEdge, _westEdge];
   return string;
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
