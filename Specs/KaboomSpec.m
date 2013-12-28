#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "Kaboom.h"
#import "Buckets.h"
#import "CCActionInterval.h"
#import "LevelLoader.h"
#import "GameBlackboard.h"
#import "Event.h"
#import "LevelCollection.h"

@interface PhonyLevelLoader : NSObject<LevelLoader>
@end

@implementation PhonyLevelLoader

+(LevelCollection *) load
{
  return [LevelCollection newWithArray:@[
      @{@"Speed" : @"60.0", @"Bombs" : @"1"},
      @{@"Speed" : @"90.0", @"Bombs" : @"2"}
  ]];
}
@end

@interface BombHitWatcher : NSObject
@property (assign) BOOL bombHit;
@end

@implementation BombHitWatcher

-(void) bombHit:(Event *) evt
{
  self.bombHit = YES;
}

@end

OCDSpec2Context(KaboomSpec) {

  Describe(@"initialization", ^{

    It(@"creates a bomber and buckets", ^{
      Kaboom *level = [Kaboom newLevelWithSize:CGSizeMake(100.0, 50.0)];

      [ExpectObj(level.bomber) toExist];
    });

    It(@"puts the bomber at the middle top", ^{
      Kaboom *level = [Kaboom newLevelWithSize:CGSizeMake(100.0, 100.0)];

      [ExpectInt(level.bomber.position.x) toBe:50.0];
      [ExpectInt(level.bomber.position.y) toBe:40.0];
    });

    It(@"puts the buckets in the middle", ^{
      Kaboom *level = [Kaboom newLevelWithSize:CGSizeMake(100.0, 50.0)];

      [ExpectInt(level.buckets.position.x) toBe:50.0];
    });

    It(@"starts the bomber on the first level", ^{
      id bomber = [OCMockObject mockForProtocol:@protocol(Bomber)];
      Kaboom *level = [Kaboom newLevelWithBomber:bomber andLevelLoader:[PhonyLevelLoader class]];

      [(NSObject<Bomber> *)[bomber expect] startAtSpeed:60.0 withBombs:1];

      [level start];

      [bomber verify];
    });

    It(@"moves to the next level when the bomber uses up the bombs", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      Kaboom *level = [Kaboom newLevelWithBomber:bomber andLevelLoader:[PhonyLevelLoader class]];

      [[[bomber stub] andReturnValue:@1] droppedBombCount];
      [[[bomber stub] andReturnValue:@YES] isOut];
      [(NSObject<Bomber> *)[bomber expect] startAtSpeed:60.0 withBombs:1];
      [(NSObject<Bomber> *)[bomber expect] startAtSpeed:90.0 withBombs:2];

      [level start];
      [level update:10.0];

      [bomber verify];
    });

    It(@"only starts the bomber once, not on each update", ^{
      id bomber = [OCMockObject mockForProtocol:@protocol(Bomber)];
      [[bomber stub] updateDroppedBombs:[OCMArg any]];
      [[bomber stub] update:1.0];
      [[[bomber stub] andReturnValue:@NO] bombHit];
      [[[bomber stub] andReturnValue:@1] droppedBombCount];
      [[[bomber stub] andReturnValue:@NO] isOut];
      Kaboom *level = [Kaboom newLevelWithBomber:bomber andLevelLoader:[PhonyLevelLoader class]];

      [(NSObject<Bomber> *)[bomber expect] startAtSpeed:60.0 withBombs:1];

      [level start];
      [level update:1.0];

      [bomber verify];
    });

    It(@"delegates update to the bomber", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      [[[bomber stub] andReturnValue:@NO] bombHit];
      [[bomber stub] updateDroppedBombs:[OCMArg any]];
      Kaboom *level = [Kaboom newLevelWithBomber:bomber];

      [[bomber expect] update:1.0];

      [level start];
      [level update:1.0];

      [bomber verify];
    });

    It(@"delegates update to the bucket", ^{
      id buckets = [OCMockObject mockForClass:[Buckets class]];
      [[[buckets stub] andReturnValue:@1] bucketCount];
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      [[buckets expect] update:1.0];

      [level start];
      [level update:1.0];

      [buckets verify];
    });

    It(@"delegates update to the bucket repeatedly", ^{
      id buckets = [OCMockObject mockForClass:[Buckets class]];
      [[[buckets stub] andReturnValue:@1] bucketCount];
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      [[[bomber stub] andReturnValue:@1] droppedBombCount];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      [[buckets expect] update:1.0];
      [[buckets expect] update:1.0];

      [level start];
      [level update:1.0];
      [level update:1.0];

      [buckets verify];
    });

    It(@"delegates tilt to the buckets", ^{
      id buckets = [OCMockObject mockForClass:[Buckets class]];
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      [[buckets expect] tilt:2.0];

      [level tilt:2.0];

      [buckets verify];
    });

    It(@"checks for caught buckets after updating their positions", ^{
      id bomber = [OCMockObject mockForProtocol:@protocol(Bomber)];
      [[bomber stub] startAtSpeed:0.0 withBombs:0];
      [[[bomber stub] andReturnValue:@NO] bombHit];
      [[[bomber stub] andReturnValue:@1] droppedBombCount];
      [[[bomber stub] andReturnValue:@NO] isOut];
      id buckets = [OCMockObject mockForClass:[Buckets class]];
      [[[buckets stub] andReturnValue:@1] bucketCount];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      [bomber setExpectationOrderMatters:YES];
      [[bomber expect] update:10];
      [[buckets expect] update:10];

      [[bomber expect] updateDroppedBombs:buckets];

      [level start];
      [level update:10];

      [bomber verify];
      [buckets verify];
    });
    
    It(@"updates the score", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      [[[bomber stub] andReturnValue:@2] updateDroppedBombs:buckets];

      [level start];
      [level update:10];
      
      [ExpectInt(level.score) toBe:2];
    });

    It(@"accumlates multiple scores", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];
      level.score = 1;

      [[[bomber stub] andReturnValue:@2] updateDroppedBombs:buckets];

      [level start];
      [level update:10];

      [ExpectInt(level.score) toBe:3];
    });

    It(@"asks if the bomber hit the ground, and removes a bucket", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      [[[bomber stub] andReturnValue:@YES] bombHit];
      [[buckets expect] removeBucket];

      [level start];
      [level update:10];

      [buckets verify];
    });

    It(@"writes a notification when a bomb hits", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      BombHitWatcher *watcher = [BombHitWatcher new];
      GameBlackboard *blackboard = [GameBlackboard sharedBlackboard];
      [blackboard registerWatcher:watcher action:@selector(bombHit:) event:kBombHit];

      [[[bomber stub] andReturnValue:@YES] bombHit];

      [level start];
      [level update:10];

      [ExpectBool(watcher.bombHit) toBeTrue];
    });

    It(@"does not write mulitiple notifications for the same bomb hit", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      BombHitWatcher *watcher = [BombHitWatcher new];
      GameBlackboard *blackboard = [GameBlackboard sharedBlackboard];
      [blackboard registerWatcher:watcher action:@selector(bombHit:) event:kBombHit];

      [[[bomber stub] andReturnValue:@YES] bombHit];

      [level start];
      [level update:10];
      watcher.bombHit = NO;
      [level update:10];

      [ExpectBool(watcher.bombHit) toBeFalse];
    });

    It(@"ends the game if there are no buckets left", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      [[[bomber stub] andReturnValue:@YES] bombHit];
      [[buckets stub] removeBucket];
      [[[buckets stub] andReturnValue:@0] bucketCount];

      [level start];
      [level update:10];

      [ExpectBool(level.gameOver) toBeTrue];
    });

    It(@"doesn't end the game if there are bombs", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      [[[bomber stub] andReturnValue:@YES] bombHit];
      [[buckets stub] removeBucket];
      [[[buckets stub] andReturnValue:@1] bucketCount];

      [level update:10];

      [ExpectBool(level.gameOver) toBeFalse];
    });

    It(@"removes the bucket and checks the bucket count AFTER checking if the bomb hit", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      [bomber setExpectationOrderMatters:YES];
      [buckets setExpectationOrderMatters:YES];
      [[[bomber expect] andReturnValue:@YES] bombHit];
      [[buckets expect] removeBucket];
      [[[buckets expect] andReturnValue:@1] bucketCount];

      [level start];
      [level update:10];

      [buckets verify];
      [bomber verify];
    });

    It(@"doesn't continue updating after game is over", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

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
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      [[[bomber stub] andReturnValue:@YES] bombHit];
      [[bomber expect] explode];

      [level start];
      [level update:10];

      [bomber verify];
    });

    It(@"doesn't keep checking for bomb hits after a bomb hits", ^{
      id bomber = [OCMockObject mockForProtocol:@protocol(Bomber)];
      [[bomber stub] startAtSpeed:0.0 withBombs:0];
      [[bomber stub] updateDroppedBombs:[OCMArg any]];
      [[bomber stub] update:10];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      [[[buckets stub] andReturnValue:@2] bucketCount];
      [[[bomber stub] andReturnValue:@YES] bombHit];
      [[bomber expect] explode];

      [level start];
      [level update:10];
      [level update:10];

      [bomber verify];
    });

    It(@"starts checking for bomb hits again after the level is restarted", ^{
      id bomber = [OCMockObject mockForProtocol:@protocol(Bomber)];
      [[bomber stub] startAtSpeed:0.0 withBombs:0];
      [[bomber stub] updateDroppedBombs:[OCMArg any]];
      [[bomber stub] update:10];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      [[[buckets stub] andReturnValue:@2] bucketCount];
      [[[bomber stub] andReturnValue:@YES] bombHit];

      [[bomber expect] explode];
      [[bomber expect] explode];

      [level start];
      [level update:10];
      [level restart];
      [level update:10];

      [bomber verify];
    });

    It(@"redoes the current level when the level is restarted", ^{

    });
  });
}
