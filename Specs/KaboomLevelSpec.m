#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "KaboomLevel.h"
#import "Buckets.h"
#import "CCActionInterval.h"

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
      [[[bomber stub] andReturnValue:@NO] bombHit];
      [[bomber stub] checkBombs:[OCMArg any]];
      KaboomLevel *level = [KaboomLevel newLevelWithBomber:bomber];

      [[bomber expect] update:1.0];

      [level update:1.0];

      [bomber verify];
    });

    It(@"delegates update to the bucket", ^{
      id buckets = [OCMockObject mockForClass:[Buckets class]];
      [[[buckets stub] andReturnValue:@1] bucketCount];
      KaboomLevel *level = [KaboomLevel newLevelWithBuckets:buckets];

      [[buckets expect] update:1.0];

      [level update:1.0];

      [buckets verify];
    });

    It(@"delegates tilt to the buckets", ^{
      id buckets = [OCMockObject mockForClass:[Buckets class]];
      KaboomLevel *level = [KaboomLevel newLevelWithBuckets:buckets];

      [[buckets expect] tilt:2.0];

      [level tilt:2.0];

      [buckets verify];
    });

    It(@"checks for caught buckets after updating their positions", ^{
      id bomber = [OCMockObject mockForProtocol:@protocol(Bomber)];
      [[[bomber stub] andReturnValue:@NO] bombHit];
      id buckets = [OCMockObject mockForClass:[Buckets class]];
      [[[buckets stub] andReturnValue:@1] bucketCount];
      KaboomLevel *level = [KaboomLevel newLevelWithBuckets:buckets bomber:bomber];

      [bomber setExpectationOrderMatters:YES];
      [[bomber expect] update:10];
      [[buckets expect] update:10];

      [[bomber expect] checkBombs:buckets];

      [level update:10];

      [bomber verify];
      [buckets verify];
    });
    
    It(@"updates the score", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      KaboomLevel *level = [KaboomLevel newLevelWithBuckets:buckets bomber:bomber];
      
      [[[bomber stub] andReturnValue:@2] checkBombs:buckets];
      
      [level update:10];
      
      [ExpectInt(level.score) toBe:2];
    });

    It(@"accumlates multiple scores", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      KaboomLevel *level = [KaboomLevel newLevelWithBuckets:buckets bomber:bomber];
      level.score = 1;

      [[[bomber stub] andReturnValue:@2] checkBombs:buckets];

      [level update:10];

      [ExpectInt(level.score) toBe:3];
    });

    It(@"asks if the bomber hit the ground, and removes a bucket", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      KaboomLevel *level = [KaboomLevel newLevelWithBuckets:buckets bomber:bomber];

      [[[bomber stub] andReturnValue:@YES] bombHit];
      [[buckets expect] removeBucket];

      [level update:10];

      [buckets verify];
    });

    It(@"ends the game if there are no buckets left", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      KaboomLevel *level = [KaboomLevel newLevelWithBuckets:buckets bomber:bomber];

      [[[bomber stub] andReturnValue:@YES] bombHit];
      [[buckets stub] removeBucket];
      [[[buckets stub] andReturnValue:@0] bucketCount];

      [level update:10];

      [ExpectBool(level.gameOver) toBeTrue];
    });

    It(@"doesn't end the game if there are bombs", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      KaboomLevel *level = [KaboomLevel newLevelWithBuckets:buckets bomber:bomber];

      [[[bomber stub] andReturnValue:@YES] bombHit];
      [[buckets stub] removeBucket];
      [[[buckets stub] andReturnValue:@1] bucketCount];

      [level update:10];

      [ExpectBool(level.gameOver) toBeFalse];
    });

    It(@"doesn't end the game if there are bombs", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      KaboomLevel *level = [KaboomLevel newLevelWithBuckets:buckets bomber:bomber];

      [bomber setExpectationOrderMatters:YES];
      [buckets setExpectationOrderMatters:YES];
      [[[bomber expect] andReturnValue:@YES] bombHit];
      [[buckets expect] removeBucket];
      [[[buckets expect] andReturnValue:@1] bucketCount];

      [level update:10];

      [buckets verify];
      [bomber verify];
    });

    It(@"doesn't continue updating after game is over", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      KaboomLevel *level = [KaboomLevel newLevelWithBuckets:buckets bomber:bomber];

      [[[bomber stub] andReturnValue:@YES] bombHit];
      [[buckets stub] removeBucket];
      [[[buckets stub] andReturnValue:@0] bucketCount];

      [level update:10];

      [[bomber reject] update:10];
      [[buckets reject] update:10];

      [level update:10];

      [buckets verify];
      [bomber verify];
    });

    It(@"Tells the bomber to blow up when a bomb hits", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      KaboomLevel *level = [KaboomLevel newLevelWithBuckets:buckets bomber:bomber];

      [[[bomber stub] andReturnValue:@YES] bombHit];
      [[bomber expect] explode];

      [level update:10];

      [bomber verify];
    });
  });
}
