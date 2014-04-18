#import <Kiwi/Kiwi.h>
#import "Kaboom.h"
#import "Buckets.h"

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

SPEC_BEGIN(KaboomSpec)

  describe(@"initialization", ^{

    it(@"creates a bomber and buckets", ^{
      Kaboom *level = [Kaboom new];

      [[level.bomber should] beNonNil];
    });

    it(@"puts the bomber at the middle top", ^{
      Kaboom *level = [Kaboom new];

      [[theValue(level.bomber.position.x) should] equal:theValue(GAME_WIDTH / 2)];
      [[theValue(level.bomber.position.y) should] equal:theValue(0)];
    });

    it(@"puts the buckets in the middle", ^{
      Kaboom *level = [Kaboom new];

      [[theValue(level.buckets.position.x) should] equal:theValue(GAME_WIDTH / 2)];
      [[theValue(level.buckets.position.y) should] equal:theValue(180.0f)];
    });

    it(@"starts bombing on the start event", ^{
      id context = [KaboomContext mock];
      Kaboom *level = [Kaboom newLevelWithContext: context];

      [[context expect] startBombing];

      [level start];
    });

    it(@"advances to the next level when the level is finished", ^{
      id context = [KaboomContext mock];
      [[context stub] updatePlayers:0];
      [[context stub] startBombing];
      Kaboom *level = [Kaboom newLevelWithContext: context];

      [level start];
      [level update:0];

      [[context expect] advanceToNextLevel];

      [level fire:@"Next Level"];
    });

    it(@"Starts updating the bomber again after moving to the next level", ^{
      id context = [KaboomContext mock];
      [[context stub] updatePlayers:10];
      [[context stub] startBombing];
      [[context stub] advanceToNextLevel];
      Kaboom *level = [Kaboom newLevelWithContext:context];

      [level start];
      [level update:10];
      [level fire:@"Next Level"];
      [level fire:@"New Level"];

      [[context expect] updatePlayers:11];

      [level update:11];
    });

    it(@"delegates update to the bomber", ^{
      id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
      [[bomber stubAndReturn:theValue(NO)] bombHit];
      [[bomber stub] updateDroppedBombs:any()];
      [[bomber stub] startAtSpeed:260 withBombs:5];
      [[bomber stub] isOut];
      Kaboom *level = [Kaboom newLevelWithBomber:bomber];

      [[bomber expect] update:1.0];

      [level start];
      [level update:1.0];
    });

    it(@"delegates update to the bucket", ^{
      id buckets = [Buckets mock];
      [[buckets stubAndReturn:theValue(1)] bucketCount];
      id bomber = [KWMock nullMockForProtocol:@protocol(Bomber)];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      [[buckets expect] update:1.0];

      [level start];
      [level update:1.0];
    });

    it(@"delegates update to the bucket repeatedly", ^{
      id buckets = [Buckets mock];
      [[buckets stubAndReturn:theValue(1)] bucketCount];
      id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
      [[bomber stub] startAtSpeed:260 withBombs:5];
      [[bomber stub] update:1.0];
      [[bomber stub] updateDroppedBombs:any()];
      [[bomber stubAndReturn:theValue(1)] droppedBombCount];
      [[bomber stub] bombHit];
      [[bomber stub] isOut];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      [[buckets expect] update:1.0];
      [[buckets expect] update:1.0];

      [level start];
      [level update:1.0];
      [level update:1.0];
    });

    it(@"delegates tilt to the buckets", ^{
      id buckets = [Buckets mock];
      id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      [[buckets expect] tilt:2.0];

      [level tilt:2.0];
    });
    
    it(@"updates the score", ^{
      id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
      [[bomber stub] startAtSpeed:260 withBombs:5];
      [[bomber stub] update:10];
      [[bomber stub] bombHit];
      [[bomber stub] isOut];
      id buckets = [Buckets mock];
      [[buckets stub] update: 10];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      [[bomber stubAndReturn:theValue(2)] updateDroppedBombs:buckets];

      [level start];
      [level update:10];
      
      [[theValue(level.score) should] equal:theValue(2)];
    });

    it(@"accumlates multiple scores", ^{
      id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
      [[bomber stub] startAtSpeed:260 withBombs:5];
      [[bomber stub] update:10];
      [[bomber stub] bombHit];
      [[bomber stub] isOut];
      id buckets = [Buckets mock];
      [[buckets stub] update:10];

      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];
      level.score = 1;

      [[bomber stubAndReturn:theValue(2)] updateDroppedBombs:buckets];

      [level start];
      [level update:10];

      [[theValue(level.score) should] equal:@3];
    });

    it(@"asks if the bomber hit the ground, and removes a bucket", ^{
      id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
      [[bomber stub] startAtSpeed:260 withBombs:5];
      [[bomber stub] update:10];
      [[bomber stub] isOut];
      [[bomber stub] explode];

      id buckets = [Buckets mock];
      [[buckets stub] update:10];
      [[buckets stub] bucketCount];
      [[bomber stubAndReturn:theValue(2)] updateDroppedBombs:buckets];

      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      [[bomber stubAndReturn:theValue(YES)] bombHit];
      [[buckets expect] removeBucket];

      [level start];
      [level update:10];
    });

    it(@"writes a notification when a bomb hits", ^{
      id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
      [[bomber stub] startAtSpeed:260 withBombs:5];
      [[bomber stub] update:10];
      [[bomber stub] isOut];
      [[bomber stub] explode];

      id buckets = [Buckets nullMock];
      [[bomber stub] updateDroppedBombs:buckets];
      
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      BombHitWatcher *watcher = [BombHitWatcher new];
      GameBlackboard *blackboard = [GameBlackboard sharedBlackboard];
      [blackboard registerWatcher:watcher action:@selector(bombHit:) event:kBombHit];

      [[bomber stubAndReturn:theValue(YES)] bombHit];

      [level start];
      [level update:10];

      [[theValue(watcher.bombHit) should] equal:@YES];
    });

    it(@"does not write mulitiple notifications for the same bomb hit", ^{
      id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
      [[bomber stub] startAtSpeed:260 withBombs:5];
      [[bomber stub] update:10];
      [[bomber stub] isOut];
      [[bomber stub] explode];

      id buckets = [Buckets nullMock];
      [[bomber stub] updateDroppedBombs:buckets];

      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      BombHitWatcher *watcher = [BombHitWatcher new];
      GameBlackboard *blackboard = [GameBlackboard sharedBlackboard];
      [blackboard registerWatcher:watcher action:@selector(bombHit:) event:kBombHit];

      [[bomber stubAndReturn:theValue(YES)] bombHit];

      [level start];
      [level update:10];
      watcher.bombHit = NO;
      [level update:10];

      [[theValue(watcher.bombHit) should] equal:@NO];
    });

    it(@"fires the endGame event when there are no buckets left", ^{
      GameBlackboard *blackboard = [GameBlackboard sharedBlackboard];
      [blackboard clear];
      GameOverWatcher *listener = [GameOverWatcher new];
      [blackboard registerWatcher:listener action:@selector(gameOver:) event:kGameOver];

      id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
      [[bomber stub] startAtSpeed:260 withBombs:5];
      [[bomber stub] update:10];
      [[bomber stub] isOut];
      [[bomber stub] explode];
      
      id buckets = [Buckets mock];
      [[buckets stub] update:10];
      [[bomber stub] updateDroppedBombs:buckets];

      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];
      [[buckets stub] removeBucket];
      
      [[bomber stubAndReturn:theValue(YES)] bombHit];
      [[buckets stubAndReturn:theValue(0)] bucketCount];

      [level start];
      [level update:10];

      [[theValue(listener.gameOver) should] equal:@YES];
    });

    it(@"doesn't fire the endGame event when there are buckets left", ^{
      GameBlackboard *blackboard = [GameBlackboard sharedBlackboard];
      [blackboard clear];
      GameOverWatcher *listener = [GameOverWatcher new];
      [blackboard registerWatcher:listener action:@selector(gameOver:) event:kGameOver];

      id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
      [[bomber stub] startAtSpeed:260 withBombs:5];
      [[bomber stub] update:10];
      [[bomber stub] isOut];
      [[bomber stub] explode];
      
      id buckets = [Buckets nullMock];
      [[bomber stub] updateDroppedBombs:buckets];
      
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];
      [[bomber stubAndReturn:theValue(YES)] bombHit];
      [[buckets stubAndReturn:theValue(1)] bucketCount];

      [level start];
      [level update:10];

      [[theValue(listener.gameOver) should] equal:@NO];
    });

    it(@"stops updating the buckets when the game is over", ^{
      id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
      [[bomber stub] startAtSpeed:260 withBombs:5];
      [[bomber stub] update:10];
      [[bomber stub] isOut];
      [[bomber stub] explode];
      
      id buckets = [Buckets nullMock];
      [[bomber stub] updateDroppedBombs:buckets];
      
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];
      [[bomber stubAndReturn:theValue(YES)] bombHit];
      [[buckets stub] removeBucket];
      [[buckets stubAndReturn:theValue(0)] bucketCount];

      [[buckets expect] update:10];

      [level start];
      [level update:10];
      [level update:11];
    });

    it(@"restarts updating game on new game", ^{
      id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
      [[bomber stub] startAtSpeed:260 withBombs:5];
      [[bomber stub] update:10];
      [[bomber stub] update:11];
      [[bomber stub] isOut];
      [[bomber stub] explode];
      
      id buckets = [Buckets mock];
      [[bomber stub] updateDroppedBombs:buckets];
      
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];
      [[bomber stubAndReturn:theValue(YES)] bombHit];
      [[buckets stub] removeBucket];
      [[buckets stubAndReturn:theValue(0)] bucketCount];
      [[buckets stub] reset];

      [[buckets expect] update:10];
      [[buckets expect] update:11];

      [level start];
      [level update:10];
      [level start];
      [level update:11];
    });

    it(@"starts bombing again on a new game", ^{
      id kaboomContext = [KaboomContext nullMock];
      Kaboom *level = [Kaboom newLevelWithContext:kaboomContext];

      [level start];
      [level update:1];
      [level fire:@"End Game"];

      [[kaboomContext expect] resetGame];

      [level start];
    });

    it(@"resets the buckets on new game", ^{
      id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
      [[bomber stub] startAtSpeed:260 withBombs:5];
      [[bomber stub] update:10];
      [[bomber stub] isOut];
      [[bomber stub] explode];
      
      id buckets = [Buckets nullMock];
      [[bomber stub] updateDroppedBombs:buckets];

      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];
      [[bomber stubAndReturn:theValue(YES)] bombHit];
      [[buckets stubAndReturn:theValue(0)] bucketCount];

      [level start];
      [level update:10];

      [[buckets expect] reset];

      [level start];
    });

    it(@"resets the score on new game", ^{
      id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
      [[bomber stub] startAtSpeed:260 withBombs:5];
      [[bomber stub] update:10];
      [[bomber stub] isOut];
      [[bomber stub] explode];
      
      id buckets = [Buckets nullMock];
      [[bomber stub] updateDroppedBombs:buckets];

      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];
      [[bomber stubAndReturn:theValue(YES)] bombHit];
      [[buckets stubAndReturn:theValue(0)] bucketCount];

      [level start];
      [level update:10];
      level.score = 2;
      [level start];

      [[theValue(level.score) should] equal:@0];
    });

    it(@"removes the bucket and checks the bucket count AFTER checking if the bomb hit", ^{
      id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
      [[bomber stub] startAtSpeed:260 withBombs:5];
      [[bomber stub] update:10];
      [[bomber stub] isOut];
      [[bomber stub] explode];
      
      id buckets = [Buckets nullMock];
      [[bomber stub] updateDroppedBombs:buckets];

      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

//      [bomber setExpectationOrderMatters:YES];
  //    [buckets setExpectationOrderMatters:YES];
      [[bomber should] receive:@selector(bombHit) andReturn:theValue(YES)];
      [[buckets should] receive:@selector(bucketCount) andReturn:theValue(1)];

      [level start];
      [level update:10];
    });

    it(@"doesn't continue updating after game is over", ^{
      id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
      
      id buckets = [Buckets mock];
      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      [[bomber stubAndReturn:theValue(YES)] bombHit];
      [[buckets stub] removeBucket];
      [[buckets stubAndReturn:theValue(0)] bucketCount];

      [level update:10];

      [[[bomber shouldNot] receive] update:10];
      [[[buckets shouldNot] receive] update:10];

      [level update:10];

    });

    it(@"Tells the bomber to blow up when a bomb hits", ^{
      id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
      [[bomber stub] startAtSpeed:260 withBombs:5];
      [[bomber stub] update:10];
      [[bomber stub] isOut];
      
      id buckets = [Buckets nullMock];
      [[bomber stub] updateDroppedBombs:buckets];

      Kaboom *level = [Kaboom newLevelWithBuckets:buckets bomber:bomber];

      [[bomber stubAndReturn:theValue(YES)] bombHit];
      [[[bomber should] receive] explode];

      [level start];
      [level update:10];
    });

    it(@"doesn't do anything on updates when exploding", ^{
      id kaboomContext = [KaboomContext mock];
      [[kaboomContext stub] startBombing];
      [[kaboomContext stub] updatePlayers:10];
      
      Kaboom *level = [Kaboom newLevelWithContext:kaboomContext];

      [level start];
      [level update:10];
      [level fire:@"Bomb Hit"];

      [[[kaboomContext shouldNot] receive] updatePlayers:12];

      [level update:12];
    });

    it(@"starts updating again when the explosion is over", ^{
      id kaboomContext = [KaboomContext mock];
      [[kaboomContext stub] updatePlayers:10];
      [[kaboomContext stub] startBombing];
      [[kaboomContext stub] restartLevel];
      
      Kaboom *level = [Kaboom newLevelWithContext:kaboomContext];

      [level start];
      [level update:10];
      [level fire:@"Bomb Hit"];
      [level restart];
      [level fire:@"Restarted"];

      [[[kaboomContext should] receive] updatePlayers:12];

      [level update:12];
    });
    
    it(@"reports the current score", ^{
      id kaboomContext = [KaboomContext nullMock];
      [[kaboomContext stubAndReturn:theValue(10)] score];
      
      Kaboom *level = [Kaboom newLevelWithContext:kaboomContext];
      [level start];
      [level update:10];
      
      [[[kaboomContext should] receive] reportScore];
      [level fire:@"End Game"];
    });
  });

SPEC_END

