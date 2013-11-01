#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "KaboomLevel.h"
#import "Buckets2D.h"

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
      id bomber = [OCMockObject mockForProtocol:@protocol(Bomber)];
      KaboomLevel *level = [KaboomLevel newLevelWithBomber:bomber];

      [(NSObject<Bomber> *)[bomber expect] start];

      [level start];

      [bomber verify];
    });

    It(@"delegates update to the bomber", ^{
      id bomber = [OCMockObject mockForProtocol:@protocol(Bomber)];
      [[bomber stub] checkBombs:[OCMArg any]];
      KaboomLevel *level = [KaboomLevel newLevelWithBomber:bomber];

      [[bomber expect] update:1.0];

      [level update:1.0];

      [bomber verify];
    });

    It(@"delegates update to the bucket", ^{
      id buckets = [OCMockObject mockForClass:[Buckets2D class]];
      KaboomLevel *level = [KaboomLevel newLevelWithBuckets:buckets];

      [[buckets expect] update:1.0];

      [level update:1.0];

      [buckets verify];
    });

    It(@"delegates tilt to the buckets", ^{
      id buckets = [OCMockObject mockForClass:[Buckets2D class]];
      KaboomLevel *level = [KaboomLevel newLevelWithBuckets:buckets];

      [[buckets expect] tilt:2.0];

      [level tilt:2.0];

      [buckets verify];
    });

    It(@"checks for caught buckets after updating their positions", ^{
      id bomber = [OCMockObject mockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject mockForClass:[Buckets2D class]];
      KaboomLevel *level = [KaboomLevel newLevelWithBuckets:buckets bomber:bomber];

      [bomber setExpectationOrderMatters:YES];
      [[bomber expect] update:10];
      [[buckets expect] update:10];

      [[bomber expect] checkBombs:buckets];

      [level update:10];

      [bomber verify];
      [buckets verify];
    });
  });
}
