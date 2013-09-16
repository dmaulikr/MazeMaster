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

@synthesize northTile = _northTile;
@synthesize eastTile = _eastTile;
@synthesize southTile = _southTile;
@synthesize westTile = _westTile;
@synthesize walkable = _walkable;

-(id) init
{
   if ( self = [super init] )
   {
      // initialize stuff
      _walkable = YES;
   }
   return self;
}

-(id) initWithNorthTile:(BOOL)northTile withSouthTile:(BOOL)southTile
{
   if ( self = [super init] )
   {
      if ( northTile )
         _northTile = [[Tile alloc] init];
      
      if ( southTile )
         _southTile = [[Tile alloc] init];
   }
   return [self init];
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
   return [self init];
}

-(NSString *) description
{
   NSString *string = [[NSString alloc] initWithFormat:
                       @"Edge: %p\n         northTile: %p\n          eastTile: %p\n          southTile: %p\n          westTile: %p",
                       self, _northTile, _eastTile, _southTile, _westTile];
   return string;
}

-(void) dealloc
{
   [super dealloc];
}

@end
