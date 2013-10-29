#import <OCDSpec2/OCDSpec2.h>
#import "Bomber.h"
#import "Constants.h"

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

OCDSpec2Context(BomberSpec) {
  
  Describe(@"moving back and forth", ^{
    
    It(@"moves towards its next spot", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[@0.0]];
      Bomber *bomber = [[Bomber alloc] initWithPosition:CGPointMake(10, 40) speed:1.0 locationChooser:locations];

      [bomber start];

      [bomber update:1.0];

      [ExpectFloat(bomber.position.x) toBe:9.0 withPrecision:0.0001];
    });

    It(@"moves its speed per update (per second)", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[@0.0]];
      Bomber *bomber = [[Bomber alloc] initWithPosition:CGPointMake(10, 40) speed:2.0 locationChooser:locations];

      [bomber start];

      [bomber update:1.0];

      [ExpectFloat(bomber.position.x) toBe:8.0 withPrecision:0.0001];
    });

    It(@"accounts for the update time when calculating tilt (speed is per second, update is in seconds)", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[@0.0]];
      Bomber *bomber = [[Bomber alloc] initWithPosition:CGPointMake(10, 40) speed:2.0 locationChooser:locations];

      [bomber start];

      [bomber update:2.0];

      [ExpectFloat(bomber.position.x) toBe:6.0 withPrecision:0.0001];
    });

    It(@"goes in the direction of the spot", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[@20.0]];
      Bomber *bomber = [[Bomber alloc] initWithPosition:CGPointMake(10, 40) speed:1.0 locationChooser:locations];

      [bomber start];

      [bomber update:1.0];

      [ExpectFloat(bomber.position.x) toBe:11.0 withPrecision:0.0001];
    });

    It(@"begins heading to the next location when it hits the first location", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[@19.0, @25.0]];
      Bomber *bomber = [[Bomber alloc] initWithPosition:CGPointMake(20, 40) speed:1.0 locationChooser:locations];

      [bomber start];

      [bomber update:1.0];
      [bomber update:1.0];

      [ExpectFloat(bomber.position.x) toBe:20.0 withPrecision:0.0001];
    });

    It(@"begins heading to the next location when it crosses - even if it doesn't hit it the next location", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[@19.0, @15.0]];
      Bomber *bomber = [[Bomber alloc] initWithPosition:CGPointMake(20, 40) speed:2.0 locationChooser:locations];

      [bomber start];

      [bomber update:1.0];
      [bomber update:1.0];

      [ExpectFloat(bomber.position.x) toBe:16.0 withPrecision:0.0001];
    });

    It(@"stops at the location when coming from the left", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[@19.0, @22.0]];
      Bomber *bomber = [[Bomber alloc] initWithPosition:CGPointMake(17, 40) speed:2.0 locationChooser:locations];

      [bomber start];

      [bomber update:1.0];
      [bomber update:1.0];

      [ExpectFloat(bomber.position.x) toBe:21.0 withPrecision:0.0001];
    });

    It(@"doesn't move until it is started", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[@19.0, @22.0]];
      Bomber *bomber = [[Bomber alloc] initWithPosition:CGPointMake(17, 40) speed:2.0 locationChooser:locations];

      [bomber update:1.0];

      [ExpectFloat(bomber.position.x) toBe:17.0 withPrecision:0.0001];
    });

    It(@"starts without any bombs", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[]];
      Bomber *bomber = [[Bomber alloc] initWithPosition:CGPointMake(17, 40) speed:2.0 locationChooser:locations];

      [ExpectInt(bomber.bombCount) toBe:0];
    });

    It(@"drops a bomb when it changes direction", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[@18.0]];
      Bomber *bomber = [[Bomber alloc] initWithPosition:CGPointMake(17.0, 40) speed:1.0 locationChooser:locations];

      [bomber start];
      [bomber update:1.0];

      [ExpectInt(bomber.bombCount) toBe:1];
    });

    It(@"starts the bomb right below the bomber", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[@18.0]];
      Bomber *bomber = [[Bomber alloc] initWithPosition:CGPointMake(17.0, 40)
                                                  speed:1.0
                                        locationChooser:locations
                                                 height:10
                                             bombHeight:20];

      [bomber start];
      [bomber update:1.0];

      // 1/2 of the bombHeight + 1/2 of the bomber height
      CGPoint bombPosition;
      [(NSValue *) bomber.bombs[0] getValue:&bombPosition];
      [ExpectInt(bombPosition.x) toBe:18];
      [ExpectInt(bombPosition.y) toBe:55];
    });

    It(@"moves the bomb on each update", ^{
      RiggedLocations *locations = [RiggedLocations newWithValues:@[@18.0]];
      Bomber *bomber = [[Bomber alloc] initWithPosition:CGPointMake(17.0, 40)
                                                  speed:1.0
                                        locationChooser:locations
                                                 height:10
                                             bombHeight:20];

      [bomber start];
      [bomber update:1.0];
      [bomber update:1.0];

      CGPoint bombPosition;
      [(NSValue *) bomber.bombs[0] getValue:&bombPosition];
      [ExpectInt(bombPosition.x) toBe:18];
      [ExpectInt(bombPosition.y) toBe:55 - kGravity];
    });
  });
  
}
