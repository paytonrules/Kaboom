#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "KaboomLevel.h"
#import "Bomber.h"
#import "Buckets.h"

OCDSpec2Context(KaboomLevelSpec) {

  Describe(@"initialization", ^{

    It(@"creates a bomber and buckets", ^{
      KaboomLevel *level = [KaboomLevel newLevelWithSize:CGSizeMake(100.0, 50.0)];

      [ExpectObj(level.bomber) toExist];
    });

    It(@"puts the bomber at the middle top", ^{
      KaboomLevel *level = [KaboomLevel newLevelWithSize:CGSizeMake(100.0, 50.0)];

      [ExpectInt(level.bomber.position.x) toBe:50.0];
      [ExpectInt(level.bomber.position.y) toBe:10.0];
    });

    It(@"puts the buckets in the middle", ^{
      KaboomLevel *level = [KaboomLevel newLevelWithSize:CGSizeMake(100.0, 50.0)];

      [ExpectInt(level.buckets.position.x) toBe:50.0];
    });

    It(@"delegates start to the bomber", ^{
      id bomber = [OCMockObject mockForClass:[Bomber class]];
      KaboomLevel *level = [KaboomLevel newLevelWithBomber:bomber];

      [(Bomber *)[bomber expect] start];

      [level start];

      [bomber verify];
    });

    It(@"delegates update to the bomber", ^{
      id bomber = [OCMockObject mockForClass:[Bomber class]];
      KaboomLevel *level = [KaboomLevel newLevelWithBomber:bomber];

      [[bomber expect] update:1.0];

      [level update:1.0];

      [bomber verify];
    });

    It(@"delegates move to the buckets", ^{
      id buckets = [OCMockObject mockForClass:[Buckets class]];
      KaboomLevel *level = [KaboomLevel newLevelWithBuckets:buckets];

      [[buckets expect] move:2.0];

      [level moveBuckets:2.0];

      [buckets verify];
    });
  });
}
