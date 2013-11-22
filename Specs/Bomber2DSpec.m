#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "Bomber2D.h"
#import "Buckets.h"
#import "Constants.h"
#import "Bomb2D.h"

@interface RiggedLocations : NSObject<LocationChooser>
+ (RiggedLocations *)newWithValues:(NSArray *)array;

@property (strong) NSMutableArray *values;
@end

@implementation RiggedLocations

-(float) next {
  float value = [(NSNumber *) [self.values firstObject] floatValue];
  if (self.values.count > 1) {
    [self.values removeObjectAtIndex:0];
  }

  return value;
}

+(RiggedLocations *) newWithValues:(NSArray *)array {
  RiggedLocations *locations = [RiggedLocations new];
  locations.values = [NSMutableArray arrayWithArray:array];
  return locations;
}

@end

OCDSpec2Context(Bomber2DSpec) {
  
  Describe(@"moving back and forth", ^{
    
    It(@"moves towards its next spot", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[@0.0]];
      Bomber2D *bomber = [[Bomber2D alloc] initWithPosition:CGPointMake(10, 40) locationChooser:locations];

      [bomber startAtSpeed:1.0 withBombs:1];

      [bomber update:1.0];

      [ExpectFloat(bomber.position.x) toBe:9.0 withPrecision:0.0001];
    });

    It(@"moves its speed per update (per second)", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[@0.0]];
      Bomber2D *bomber = [[Bomber2D alloc] initWithPosition:CGPointMake(10, 40) locationChooser:locations];

      [bomber startAtSpeed:2.0 withBombs:1];

      [bomber update:1.0];

      [ExpectFloat(bomber.position.x) toBe:8.0 withPrecision:0.0001];
    });

    It(@"accounts for the update time when calculating tilt (speed is per second, update is in seconds)", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[@0.0]];
      Bomber2D *bomber = [[Bomber2D alloc] initWithPosition:CGPointMake(10, 40) locationChooser:locations];

      [bomber startAtSpeed:2.0 withBombs:1];

      [bomber update:2.0];

      [ExpectFloat(bomber.position.x) toBe:6.0 withPrecision:0.0001];
    });

    It(@"goes in the direction of the spot", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[@20.0]];
      Bomber2D *bomber = [[Bomber2D alloc] initWithPosition:CGPointMake(10, 40) locationChooser:locations];

      [bomber startAtSpeed:1.0 withBombs:1];

      [bomber update:1.0];

      [ExpectFloat(bomber.position.x) toBe:11.0 withPrecision:0.0001];
    });

    It(@"begins heading to the next location when it hits the first location", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[@19.0, @25.0]];
      Bomber2D *bomber = [[Bomber2D alloc] initWithPosition:CGPointMake(20, 40) locationChooser:locations];

      [bomber startAtSpeed:1.0 withBombs:1];

      [bomber update:1.0];
      [bomber update:1.0];

      [ExpectFloat(bomber.position.x) toBe:20.0 withPrecision:0.0001];
    });

    It(@"begins heading to the next location when it crosses - even if it doesn't hit it the next location", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[@19.0, @15.0]];
      Bomber2D *bomber = [[Bomber2D alloc] initWithPosition:CGPointMake(20, 40) locationChooser:locations];

      [bomber startAtSpeed:2.0 withBombs:1];

      [bomber update:1.0];
      [bomber update:1.0];

      [ExpectFloat(bomber.position.x) toBe:16.0 withPrecision:0.0001];
    });

    It(@"stops at the location when coming from the left", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[@19.0, @22.0]];
      Bomber2D *bomber = [[Bomber2D alloc] initWithPosition:CGPointMake(17, 40) locationChooser:locations];

      [bomber startAtSpeed:2.0 withBombs:1];

      [bomber update:1.0];
      [bomber update:1.0];

      [ExpectFloat(bomber.position.x) toBe:21.0 withPrecision:0.0001];
    });

    It(@"doesn't move until it is started", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[@19.0, @22.0]];
      Bomber2D *bomber = [[Bomber2D alloc] initWithPosition:CGPointMake(17, 40) locationChooser:locations];

      [bomber update:1.0];

      [ExpectFloat(bomber.position.x) toBe:17.0 withPrecision:0.0001];
    });

    It(@"starts without any bombs", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[]];
      Bomber2D *bomber = [[Bomber2D alloc] initWithPosition:CGPointMake(17, 40) locationChooser:locations];

      [ExpectInt(bomber.bombCount) toBe:0];
    });

    It(@"drops a bomb when it changes direction", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[@18.0]];
      Bomber2D *bomber = [[Bomber2D alloc] initWithPosition:CGPointMake(17.0, 40) locationChooser:locations];

      [bomber startAtSpeed:1.0 withBombs:1];
      [bomber update:1.0];

      [ExpectInt(bomber.bombCount) toBe:1];
    });

    It(@"starts the bomb right below the bomber", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[@18.0]];
      Bomber2D *bomber = [[Bomber2D alloc] initWithPosition:CGPointMake(17.0, 90)
                                        locationChooser:locations
                                                 height:10
                                             bombHeight:20];

      [bomber startAtSpeed:1.0 withBombs:1];
      [bomber update:1.0];

      // 1/2 of the bombHeight + 1/2 of the bomber height
      NSObject<Bomb> *bomb = bomber.bombs[0];
      [ExpectInt(bomb.position.x) toBe:18];
      [ExpectInt(bomb.position.y) toBe:(90 - (10 / 2) - (20 / 2))];
    });

    It(@"moves the bomb on each update", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[@18.0, @40.0]];
      Bomber2D *bomber = [[Bomber2D alloc] initWithPosition:CGPointMake(17.0, 90)
                                        locationChooser:locations
                                                 height:10
                                             bombHeight:20];

      [bomber startAtSpeed:1.0 withBombs:1];
      [bomber update:1.0];
      [bomber update:1.0];

      CGPoint bombPosition = ((NSObject<Bomb> *) bomber.bombs[0]).position;
      [ExpectInt(bombPosition.x) toBe:18];
      [ExpectInt(bombPosition.y) toBe:75 - kGravity];
    });

    It(@"does nothing if the bomber hasn't dropped bombs", ^{
      id buckets = [OCMockObject mockForClass:[Buckets class]];
      Bomber2D *bomber = [Bomber2D new];

      [ExpectInt([bomber checkBombs:buckets]) toBe:0];

      [buckets verify];
    });

    It(@"removes any bombs that intersect buckets", ^{
      id buckets = [OCMockObject mockForClass:[Buckets class]];
      Bomber2D *bomber = [Bomber2D new];
      [bomber dropBomb];
      [bomber move:1.0];
      [bomber dropBomb];

      [[[buckets stub] andReturnValue:@YES] caughtBomb:bomber.bombs[0]];
      [[[buckets stub] andReturnValue:@YES] caughtBomb:bomber.bombs[1]];

      [ExpectInt([bomber checkBombs:buckets]) toBe:2];

      [ExpectInt(bomber.bombCount) toBe:0];
    });

    It(@"doesn't remove bombs if they don't intersect buckets", ^{
      id buckets = [OCMockObject mockForClass:[Buckets class]];
      Bomber2D *bomber = [Bomber2D new];

      [bomber dropBomb];
      [bomber move:1.0];
      [bomber dropBomb];

      [[[buckets stub] andReturnValue:@YES] caughtBomb:bomber.bombs[0]];
      [[[buckets stub] andReturnValue:@NO] caughtBomb:bomber.bombs[1]];

      [bomber checkBombs:buckets];

      [ExpectInt(bomber.bombCount) toBe:1];
    });

    It(@"says a bomb hit if any of its bombs hit", ^{
      Bomber2D *bomber = [Bomber2D new];
      [bomber dropBomb];
      Bomb2D *bomb = (Bomb2D *) bomber.bombs[0];
      bomb.boundingBox = CGRectMake(0, -1, 1, 2);

      [ExpectBool([bomber bombHit]) toBeTrue];
    });

    It(@"doesnt say a bomb hit if it there are no dropped bombs", ^{
      Bomber2D *bomber = [Bomber2D new];

      [ExpectBool([bomber bombHit]) toBeFalse];
    });

    It(@"removes any dropped bombs on explode", ^{
      Bomber2D *bomber = [Bomber2D new];
      [bomber dropBomb];

      [bomber explode];

      [ExpectInt(bomber.bombCount) toBe:0];
    });
  });
}
