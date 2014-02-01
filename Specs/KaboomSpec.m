#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "Kaboom.h"
#import "Buckets.h"
#import "CCActionInterval.h"
#import "Constants.h"
#import "GameBlackboard.h"
#import "Event.h"
#import "LevelCollectionArray.h"
#import "KaboomContext.h"

@interface BombHitWatcher : NSObject
@property (assign) BOOL bombHit;
@end

@implementation BombHitWatcher

-(void) bombHit:(Event *) evt
{
  self.bombHit = YES;
}

@end

@interface GameOverWatcher : NSObject
@property (assign) BOOL gameOver;
@end

@implementation GameOverWatcher

-(void) gameOver:(Event *) evt
{
  self.gameOver = YES;
}
@end

OCDSpec2Context(KaboomSpec) {

  Describe(@"initialization", ^{

    It(@"creates a bomber and buckets", ^{
      Kaboom *level = [Kaboom new];

      [ExpectObj(level.bomber) toExist];
    });

    It(@"puts the bomber at the middle top", ^{
      Kaboom *level = [Kaboom new];

      [ExpectInt(level.bomber.position.x) toBe:GAME_WIDTH / 2];
      [ExpectInt(level.bomber.position.y) toBe:0];
    });

    It(@"puts the buckets in the middle", ^{
      Kaboom *level = [Kaboom new];

      [ExpectInt(level.buckets.position.x) toBe:GAME_WIDTH / 2];
      [ExpectInt(level.buckets.position.y) toBe:180.0f];
    });

    It(@"starts bombing on the start event", ^{
      id context = [OCMockObject mockForClass:[KaboomContext class]];
      Kaboom *level = [Kaboom newLevelWithContext: context];

      [[context expect] startBombing];

      [level start];

      [context verify];
    });

    It(@"advances to the next level when the level is finished", ^{
      id context = [OCMockObject niceMockForClass:[KaboomContext class]];
      Kaboom *level = [Kaboom newLevelWithContext: context];

      [level start];
      [level update:0];

      [[context expect] advanceToNextLevel];

      [level fire:@"Next Level"];

      [context verify];
    });

    It(@"Starts updating the bomber again after moving to the next level", ^{
      id context = [OCMockObject niceMockForClass:[KaboomContext class]];
      Kaboom *level = [Kaboom newLevelWithContext:context];

      [level start];
      [level update:10];
      [level fire:@"Next Level"];
      [level fire:@"New Level"];

      [[context expect] updatePlayers:11];

      [level update:11];

      [context verify];
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

    It(@"fires the endGame event when there are no buckets left", ^{
      GameBlackboard *blackboard = [GameBlackboard sharedBlackboard];
      [blackboard clear];
      GameOverWatcher *listener = [GameOverWatcher new];
      [blackboard registerWatcher:listener action:@selector(gameOver:) event:kGameOver];

      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];
      [[[bomber stub] andReturnValue:@YES] bombHit];
      [[buckets stub] removeBucket];
      [[[buckets stub] andReturnValue:@0] bucketCount];

      [level start];
      [level update:10];

      [ExpectBool(listener.gameOver) toBeTrue];
    });

    It(@"doesn't fire the endGame event when there are buckets left", ^{
      GameBlackboard *blackboard = [GameBlackboard sharedBlackboard];
      [blackboard clear];
      GameOverWatcher *listener = [GameOverWatcher new];
      [blackboard registerWatcher:listener action:@selector(gameOver:) event:kGameOver];

      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];
      [[[bomber stub] andReturnValue:@YES] bombHit];
      [[buckets stub] removeBucket];
      [[[buckets stub] andReturnValue:@1] bucketCount];

      [level start];
      [level update:10];

      [ExpectBool(listener.gameOver) toBeFalse];
    });

    It(@"stops updating the buckets when the game is over", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject mockForClass:[Buckets class]];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];
      [[[bomber stub] andReturnValue:@YES] bombHit];
      [[buckets stub] removeBucket];
      [[[buckets stub] andReturnValue:@0] bucketCount];

      [[buckets expect] update:10];

      [level start];
      [level update:10];
      [level update:11];

      [buckets verify];
    });

    It(@"restarts updating game on new game", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject mockForClass:[Buckets class]];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];
      [[[bomber stub] andReturnValue:@YES] bombHit];
      [[buckets stub] removeBucket];
      [[[buckets stub] andReturnValue:@0] bucketCount];
      [[buckets stub] reset];

      [[buckets expect] update:10];
      [[buckets expect] update:11];

      [level start];
      [level update:10];
      [level start];
      [level update:11];

      [buckets verify];
    });

    It(@"starts bombing again on a new game", ^{
      id kaboomContext = [OCMockObject niceMockForClass:[KaboomContext class]];
      Kaboom *level = [Kaboom newLevelWithContext:kaboomContext];

      [level start];
      [level update:1];
      [level fire:@"End Game"];

      [[kaboomContext expect] resetGame];

      [level start];

      [kaboomContext verify];
    });

    It(@"resets the buckets on new game", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];
      [[[bomber stub] andReturnValue:@YES] bombHit];
      [[buckets stub] removeBucket];
      [[[buckets stub] andReturnValue:@0] bucketCount];

      [level start];
      [level update:10];

      [[buckets expect] reset];

      [level start];

      [buckets verify];
    });

    It(@"resets the score on new game", ^{
      id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
      id buckets = [OCMockObject niceMockForClass:[Buckets class]];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];
      [[[bomber stub] andReturnValue:@YES] bombHit];
      [[buckets stub] removeBucket];
      [[[buckets stub] andReturnValue:@0] bucketCount];

      [level start];
      [level update:10];
      level.score = 2;
      [level start];

      [ExpectInt(level.score) toBe:0];
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

    It(@"doesn't do anything on updates when exploding", ^{
      id kaboomContext = [OCMockObject niceMockForClass:[KaboomContext class]];
      Kaboom *level = [Kaboom newLevelWithContext:kaboomContext];

      [level start];
      [level update:10];
      [level fire:@"Bomb Hit"];

      [[kaboomContext reject] updatePlayers:12];

      [level update:12];

      [kaboomContext verify];
    });

    It(@"starts updating again when the explosion is over", ^{
      id kaboomContext = [OCMockObject niceMockForClass:[KaboomContext class]];
      Kaboom *level = [Kaboom newLevelWithContext:kaboomContext];

      [level start];
      [level update:10];
      [level fire:@"Bomb Hit"];
      [level restart];
      [level fire:@"Restarted"];

      [[kaboomContext expect] updatePlayers:12];

      [level update:12];

      [kaboomContext verify];
    });
  });
}
