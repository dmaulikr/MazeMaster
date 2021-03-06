//
//  MMLevel.m
//  MazeMaster
//
//  Created by Justin Fila on 8/13/13.
//  Copyright (c) 2013 Binary Gods. All rights reserved.
//

#import "MMLevel.h"
#import "MMMaze.h"
#import "MMEnemy.h"
#import "MMVictim.h"
#import "MMGameController.h"
#import "MMGameLayer.h"
#import "MMMazeLayer.h"
#import "MMTile.h"

@interface MMLevel()
{
   MMMaze* _maze;
   int _levelNumber;
}
@end

@implementation MMLevel

@synthesize levelNumber = _levelNumber;
@synthesize maze = _maze;

-(id) init
{
   if ( self = [super init] )
   {
      _maze = [[MMMaze alloc] initWithRows:5
                             withColumns:5];
//      [_maze testMaze];
      [self initEnemies];
      [self initVictims];
   }
   return self;
}

-(id) initWithRows:(int)rows andColumns:(int)cols
{
   if ( self = [super init] )
   {
      _maze = [[MMMaze alloc] initWithRows:rows
                             withColumns:cols];
      [self initEnemies];
      [self initVictims];
   }
   return self;
}

// TODO: general initialize function?
-(void) initEnemies
{
   _enemies = [NSMutableArray new];
}

-(void) initVictims
{
   _victims = [NSMutableArray new];
}

-(void) dealloc
{
   [_maze release];
   [_enemies release];
   [_victims release];
   [super dealloc];
}

- (void)setLevelNumber:(int)levelNumber
{
   _levelNumber = levelNumber;
   switch (_levelNumber)
   {
      case 1:
         [self setupEdgesForLevel1];
         [self setupEnemiesForLevel1];
         [self setupVictimsForLevel1];
         break;
      default:
         break;
   }
}

// This is terrible and the brute force here needs to be thought over again
- (void)setupEdgesForLevel1
{
   for (NSMutableArray *tiles in _maze.tiles)
      for (MMTile *tile in tiles)
      {
         CGPoint tilePos = tile.position;
         if (CGPointEqualToPoint(tilePos, ccp(1,5))   ||
             CGPointEqualToPoint(tilePos, ccp(1,6))   ||
             CGPointEqualToPoint(tilePos, ccp(1,7))   ||
             CGPointEqualToPoint(tilePos, ccp(1,9))   ||
             CGPointEqualToPoint(tilePos, ccp(1,10))  ||
             CGPointEqualToPoint(tilePos, ccp(2,1))   ||
             CGPointEqualToPoint(tilePos, ccp(2,2))   ||
             CGPointEqualToPoint(tilePos, ccp(2,7))   ||
             CGPointEqualToPoint(tilePos, ccp(2,9))   ||
             CGPointEqualToPoint(tilePos, ccp(2,10))  ||
             CGPointEqualToPoint(tilePos, ccp(2,11))  ||
             CGPointEqualToPoint(tilePos, ccp(3,10))  ||
             CGPointEqualToPoint(tilePos, ccp(3,11))  ||
             CGPointEqualToPoint(tilePos, ccp(4,3))   ||
             CGPointEqualToPoint(tilePos, ccp(4,4))   ||
             CGPointEqualToPoint(tilePos, ccp(4,8))   ||
             CGPointEqualToPoint(tilePos, ccp(4,9))   ||
             CGPointEqualToPoint(tilePos, ccp(5,2))   ||
             CGPointEqualToPoint(tilePos, ccp(5,9))   ||
             CGPointEqualToPoint(tilePos, ccp(5,10))  ||
             CGPointEqualToPoint(tilePos, ccp(5,11))  ||
             CGPointEqualToPoint(tilePos, ccp(5,12))  ||
             CGPointEqualToPoint(tilePos, ccp(6,1))   ||
             CGPointEqualToPoint(tilePos, ccp(6,2))   ||
             CGPointEqualToPoint(tilePos, ccp(6,3))   ||
             CGPointEqualToPoint(tilePos, ccp(6,8))   ||
             CGPointEqualToPoint(tilePos, ccp(6,9))   ||
             CGPointEqualToPoint(tilePos, ccp(7,2))   ||
             CGPointEqualToPoint(tilePos, ccp(7,7))   ||
             CGPointEqualToPoint(tilePos, ccp(7,8))   ||
             CGPointEqualToPoint(tilePos, ccp(7,9))   ||
             CGPointEqualToPoint(tilePos, ccp(7,10))  ||
             CGPointEqualToPoint(tilePos, ccp(8,3))   ||
             CGPointEqualToPoint(tilePos, ccp(8,4))   ||
             CGPointEqualToPoint(tilePos, ccp(8,5))   ||
             CGPointEqualToPoint(tilePos, ccp(8,11))  ||
             CGPointEqualToPoint(tilePos, ccp(8,12))  ||
             CGPointEqualToPoint(tilePos, ccp(9,4))   ||
             CGPointEqualToPoint(tilePos, ccp(9,5))   ||
             CGPointEqualToPoint(tilePos, ccp(9,6))   ||
             CGPointEqualToPoint(tilePos, ccp(9,7))   ||
             CGPointEqualToPoint(tilePos, ccp(9,10))  ||
             CGPointEqualToPoint(tilePos, ccp(10,1))  ||
             CGPointEqualToPoint(tilePos, ccp(10,6))  ||
             CGPointEqualToPoint(tilePos, ccp(10,7))  ||
             CGPointEqualToPoint(tilePos, ccp(10,8))  ||
             CGPointEqualToPoint(tilePos, ccp(10,12)) ||
             CGPointEqualToPoint(tilePos, ccp(11,1))  ||
             CGPointEqualToPoint(tilePos, ccp(11,2))  ||
             CGPointEqualToPoint(tilePos, ccp(11,3))  ||
             CGPointEqualToPoint(tilePos, ccp(12,5))  ||
             CGPointEqualToPoint(tilePos, ccp(12,8))  ||
             CGPointEqualToPoint(tilePos, ccp(12,9))  ||
             CGPointEqualToPoint(tilePos, ccp(12,10)))
            tile.eastEdge.walkable = NO;

         if (CGPointEqualToPoint(tilePos, ccp(1,4))   ||
             CGPointEqualToPoint(tilePos, ccp(2,4))   ||
             CGPointEqualToPoint(tilePos, ccp(2,7))   ||
             CGPointEqualToPoint(tilePos, ccp(2,8))   ||
             CGPointEqualToPoint(tilePos, ccp(3,4))   ||
             CGPointEqualToPoint(tilePos, ccp(3,6))   ||
             CGPointEqualToPoint(tilePos, ccp(3,11))  ||
             CGPointEqualToPoint(tilePos, ccp(4,4))   ||
             CGPointEqualToPoint(tilePos, ccp(4,6))   ||
             CGPointEqualToPoint(tilePos, ccp(5,2))   ||
             CGPointEqualToPoint(tilePos, ccp(5,7))   ||
             CGPointEqualToPoint(tilePos, ccp(6,5))   ||
             CGPointEqualToPoint(tilePos, ccp(6,7))   ||
             CGPointEqualToPoint(tilePos, ccp(6,12))  ||
             CGPointEqualToPoint(tilePos, ccp(7,5))   ||
             CGPointEqualToPoint(tilePos, ccp(7,6))   ||
             CGPointEqualToPoint(tilePos, ccp(7,12))  ||
             CGPointEqualToPoint(tilePos, ccp(8,1))   ||
             CGPointEqualToPoint(tilePos, ccp(8,5))   ||
             CGPointEqualToPoint(tilePos, ccp(8,12))  ||
             CGPointEqualToPoint(tilePos, ccp(9,1))   ||
             CGPointEqualToPoint(tilePos, ccp(9,11))  ||
             CGPointEqualToPoint(tilePos, ccp(10,1))  ||
             CGPointEqualToPoint(tilePos, ccp(10,5))  ||
             CGPointEqualToPoint(tilePos, ccp(10,10)) ||
             CGPointEqualToPoint(tilePos, ccp(10,11)) ||
             CGPointEqualToPoint(tilePos, ccp(11,3))  ||
             CGPointEqualToPoint(tilePos, ccp(11,5))  ||
             CGPointEqualToPoint(tilePos, ccp(11,8))  ||
             CGPointEqualToPoint(tilePos, ccp(11,10)) ||
             CGPointEqualToPoint(tilePos, ccp(11,12)) ||
             CGPointEqualToPoint(tilePos, ccp(12,5))  ||
             CGPointEqualToPoint(tilePos, ccp(12,7))  ||
             CGPointEqualToPoint(tilePos, ccp(12,10)) ||
             CGPointEqualToPoint(tilePos, ccp(12,12)))
            tile.northEdge.walkable = NO;
      }
}

//-(void) setupEnemy:(CGPoint)location withFile:(NSString *)file
//{
//   MMGameController *gameController = [MMGameController sharedController];
//   
//   MMEnemy *enemy = [[MMEnemy alloc] initWithFile:file];
//   enemy.anchorPoint = CGPointZero;
//   enemy.currentTile = [_maze tileAtPosition:location];
//   enemy.scale = 1.8;
//   //TODO get the tile size
//   enemy.offset = ccp(44.0/2.0 - enemy.boundingBox.size.width/2.0,
//                      44.0/2.0 - enemy.boundingBox.size.height/2.0);
//   enemy.position = ccp(enemy.currentTile.tileSprite.position.x +
//                        gameController.gameLayer.mazeLayer.position.x +
//                        enemy.offset.x,
//                        enemy.currentTile.tileSprite.position.y +
//                        gameController.gameLayer.mazeLayer.position.y +
//                        enemy.offset.y );
//
//   [enemy setAwarenessProximityWithSize:CGSizeMake(264, 264)];
//
//   [_enemies addObject:enemy];
//}

-(void) addEnemiesToLayer:(CCLayer *)gameLayer
{
   for (MMEnemy *enemy in _enemies)
      [gameLayer addChild:enemy];
}

-(void) addVictimsToLayer:(CCLayer *)gameLayer
{
   for (MMVictim *victim in _victims)
      [gameLayer addChild:victim];
}

- (void)setEnemyTargets:(MMTile *)tile
{
   for (MMEnemy *enemy in _enemies)
      enemy.target = tile;
}

- (void)setupEnemy:(MMEnemy *)enemy atLocation:(CGPoint)location
{
   MMGameController *gameController = [MMGameController sharedController];

   enemy.currentTile = [_maze tileAtPosition:location];
   enemy.scale = 1.8;
   enemy.offset = ccp(44.0/2.0 - enemy.boundingBox.size.width/2.0,
                      44.0/2.0 - enemy.boundingBox.size.height/2.0);

   enemy.anchorPoint = CGPointZero;
   enemy.position = ccp(enemy.currentTile.tileSprite.position.x +
                        gameController.gameLayer.mazeLayer.position.x +
                        enemy.offset.x,
                        enemy.currentTile.tileSprite.position.y +
                        gameController.gameLayer.mazeLayer.position.y +
                        enemy.offset.y);

   [enemy setAwarenessProximityWithSize:ENEMY_AWARENESS_PROXIMITY_DEFAULT];
   enemy.maxVelocity = ccp(.9,.9);
}

- (void)setupVictim:(MMVictim *)victim atLocation:(CGPoint)location
{
   MMGameController *gameController = [MMGameController sharedController];

   victim.currentTile = [_maze tileAtPosition:location];
   victim.scale = 1.0;
   victim.offset = ccp(44.0/2.0 - victim.boundingBox.size.width/2.0,
                      44.0/2.0 - victim.boundingBox.size.height/2.0);

   victim.anchorPoint = CGPointZero;
   victim.position = ccp(victim.currentTile.tileSprite.position.x +
                        gameController.gameLayer.mazeLayer.position.x +
                        victim.offset.x,
                        victim.currentTile.tileSprite.position.y +
                        gameController.gameLayer.mazeLayer.position.y +
                        victim.offset.y);

   victim.maxVelocity = ccp(.9,.9);
}

- (void)setEnemyPositions
{
   switch (_levelNumber)
   {
      case 1:
      {
         [self setupEnemy:[_enemies objectAtIndex:0]
               atLocation:ccp(5,5)];

//         [self setupEnemy:[_enemies objectAtIndex:1]
//               atLocation:ccp(8,3)];
         break;
      }
      default:
         return;
   }
}

- (void)setVictimPositions
{
   switch (_levelNumber)
   {
      case 1:
      {
         [self setupVictim:[_victims objectAtIndex:0]
               atLocation:ccp(2,3)];

         [self setupVictim:[_victims objectAtIndex:1]
               atLocation:ccp(4,4)];
         
         break;
      }
      default:
         return;
   }
}

-(void) setupEnemiesForLevel1
{
   MMEnemy *enemy;
   enemy = [[MMEnemy alloc] initWithFile:@"enemy_front_sleeping.png"];
   [enemy setupPathFinderWithTravelerKey:@"enemy1"];
   [_enemies addObject:enemy];

//   MMEnemy *enemy2 = [[MMEnemy alloc] initWithFile:@"enemy_front_sleeping.png"];
//   [enemy2 setupPathFinderWithTravelerKey:@"enemy2"];
//   enemy2.tileGenerationOrder = e_COUNTERCLOCKWISE;
//   [_enemies addObject:enemy2];
}

-(void) setupVictimsForLevel1
{
   MMVictim *victim;
   
   victim = [[MMVictim alloc] initWithFile:@"pikmin_red_front.png"];
   [_victims addObject:victim];
   
   victim = [[MMVictim alloc] initWithFile:@"pikmin_yellow_front.png"];
   [_victims addObject:victim];
}

@end
