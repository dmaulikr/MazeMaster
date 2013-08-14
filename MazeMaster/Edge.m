//
//  Edge.m
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "Edge.h"
#import "Tile.h"

@implementation Edge

-(id) initWithNorthTile:(BOOL)northTile withSouthTile:(BOOL)southTile
{
   if ( self = [super init] )
   {
      if ( northTile )
         _northTile = [[Tile alloc] init];
      
      if ( southTile )
         _southTile = [[Tile alloc] init];
   }
   return self;
}

-(id) initWithEastTile:(BOOL)eastTile withWestTile:(BOOL)westTile
{
   if ( self = [super init] )
   {
      if ( eastTile )
         _eastTile = [[Tile alloc] init];
      
      if ( westTile )
         _westTile = [[Tile alloc] init];
   }
   return self;
}

-(void) dealloc
{
   [super dealloc];
   
   if ( _northTile )
      [_northTile release];
   
   if ( _eastTile )
      [_eastTile release];
   
   if ( _southTile )
      [_southTile release];
   
   if ( _westTile )
      [_westTile release];
}

@end
