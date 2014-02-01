#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "KaboomContext.h"
#import "LevelCollectionArray.h"
#import "Bomber.h"
#import "Buckets.h"

// Most of these specs are still in the KaboomSpec
// Remove the ManualLevelStuff - your current one will already do that
OCDSpec2Context(KaboomContextSpec) {

  Describe(@"Kaboom Context", ^{
    __block KaboomContext *kaboomContext;
    __block id machine;

    BeforeEach(^{
      machine = [OCMockObject niceMockForProtocol:@protocol(KaboomStateMachine)];
      kaboomContext = [KaboomContext newWithMachine:machine];

      kaboomContext.levels = [LevelCollectionArray newWithArray:@[@{
          @"Speed" : @1,
          @"Bombs" : @1
      }, @{
          @"Speed" : @2,
          @"Bombs" : @2
      }]];
    });

    Describe(@"advancing the levels", ^{

      It(@"sets the levels at the first one on start bombing", ^{
        id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
        kaboomContext.bomber = bomber;

        [[bomber expect] startAtSpeed:1 withBombs:1];

        [kaboomContext startBombing];

        [bomber verify];
      });

      It(@"resets the games level back to the first level", ^{
        id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
        kaboomContext.bomber = bomber;

        [[bomber expect] startAtSpeed:1 withBombs:1];

        [kaboomContext advanceToNextLevel];
        [kaboomContext resetGame];

        [[bomber expect] startAtSpeed:1 withBombs:1];

        [kaboomContext startBombing];

        [bomber verify];
      });

      It(@"moves to the next level when the bomber uses up the bombs", ^{
        id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
        kaboomContext.bomber = bomber;

        [[[bomber stub] andReturnValue:@YES] isOut];
        [[[bomber stub] andReturnValue:@NO] bombHit];

        [[machine expect] fire:@"Next Level"];

        [kaboomContext updatePlayers:10.0];

        [machine verify];
      });

      It(@"requests a new level when advancing to the next level", ^{
        id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
        kaboomContext.bomber = bomber;

        [[machine expect] fire:@"New Level"];

        [kaboomContext advanceToNextLevel];

        [machine verify];
      });

      It(@"starts the bomber at the next level", ^{
        id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
        kaboomContext.bomber = bomber;

        [[bomber expect] startAtSpeed:2 withBombs:2];

        [kaboomContext advanceToNextLevel];

        [bomber verify];
      });
    });

    Describe(@"updating players", ^{

      It(@"checks for caught buckets after updating their positions", ^{
        id bomber = [OCMockObject mockForProtocol:@protocol(Bomber)];
        [[bomber stub] startAtSpeed:0.0 withBombs:0];
        [[[bomber stub] andReturnValue:@NO] bombHit];
        [[[bomber stub] andReturnValue:@1] droppedBombCount];
        [[[bomber stub] andReturnValue:@NO] isOut];
        id buckets = [OCMockObject mockForClass:[Buckets class]];
        [[[buckets stub] andReturnValue:@1] bucketCount];

        kaboomContext.bomber = bomber;
        kaboomContext.buckets = buckets;

        [bomber setExpectationOrderMatters:YES];
        [[bomber expect] update:10];
        [[buckets expect] update:10];

        [[bomber expect] updateDroppedBombs:buckets];

        [kaboomContext updatePlayers:10];

        [bomber verify];
        [buckets verify];
      });

    });

    Describe(@"ending a game", ^{

      It(@"will fire an end game when the user is out of buckets", ^{
        id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
        id buckets = [OCMockObject mockForClass:[Buckets class]];
        kaboomContext.bomber = bomber;
        kaboomContext.buckets = buckets;

        [[[bomber stub] andReturnValue:@YES] bombHit];
        [[buckets stub] removeBucket];
        [[buckets stub] update:10.0];
        [[[buckets stub] andReturnValue:@0] bucketCount];
        [[buckets stub] reset];

        [[machine expect] fire:@"End Game"];

        [kaboomContext updatePlayers:10];

        [machine verify];
      });
    });

    Describe(@"bombs hitting", ^{

      It(@"starts exploding when a bomb hits", ^{
        id bomber = [OCMockObject niceMockForProtocol:@protocol(Bomber)];
        [[[bomber stub] andReturnValue:@YES] bombHit];
        id buckets = [OCMockObject niceMockForClass:[Buckets class]];
        [[[buckets stub] andReturnValue:@1] bucketCount];
        kaboomContext.bomber = bomber;
        kaboomContext.buckets = buckets;

        [[machine expect] fire:@"Bomb Hit"];

        [kaboomContext updatePlayers:1];

        [machine verify];
      });

    });
  });


}