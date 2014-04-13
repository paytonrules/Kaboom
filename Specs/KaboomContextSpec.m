#import <Kiwi/Kiwi.h>
#import "KaboomContext.h"
#import "LevelCollectionArray.h"
#import "Bomber.h"
#import "Buckets.h"

// Most of these specs are still in the KaboomSpec
SPEC_BEGIN(KaboomContextSpec)

  describe(@"Kaboom Context", ^{
    __block KaboomContext *kaboomContext;
    __block id machine;

    beforeEach(^{
      machine = [KWMock mockForProtocol:@protocol(KaboomStateMachine)];
      kaboomContext = [KaboomContext newWithMachine:machine];

      kaboomContext.levels = [LevelCollectionArray newWithArray:@[@{
          @"Speed" : @1,
          @"Bombs" : @1
      }, @{
          @"Speed" : @2,
          @"Bombs" : @2
      }]];
    });

    describe(@"advancing the levels", ^{

      it(@"sets the levels at the first one on start bombing", ^{
        [[machine stub] fire:any()];
        id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
        kaboomContext.bomber = bomber;

        [[bomber expect] startAtSpeed:1 withBombs:1];

        [kaboomContext startBombing];
      });

      it(@"resets the games level back to the first level", ^{
        [[machine stub] fire:any()];
        id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
        kaboomContext.bomber = bomber;

        [[bomber expect] startAtSpeed:2 withBombs:2];

        [kaboomContext advanceToNextLevel];
        
        [[bomber expect] startAtSpeed:1 withBombs:1];
        [kaboomContext resetGame];
      });

      it(@"moves to the next level when the bomber uses up the bombs", ^{
        id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
        kaboomContext.bomber = bomber;
        
        [[bomber stub] update:10.0];
        [[bomber stub] updateDroppedBombs:any()];
        [[bomber stubAndReturn:theValue(YES)] isOut];
        [[bomber stubAndReturn:theValue(NO)] bombHit];

        [[machine expect] fire:@"Next Level"];

        [kaboomContext updatePlayers:10.0];
      });

      it(@"requests a new level when advancing to the next level", ^{
        [[machine expect] fire:@"New Level"];

        [kaboomContext advanceToNextLevel];
      });

      it(@"starts the bomber at the next level", ^{
        [[machine stub] fire:any()];
        id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
        kaboomContext.bomber = bomber;

        [[bomber expect] startAtSpeed:2 withBombs:2];

        [kaboomContext advanceToNextLevel];
      });
    });

    describe(@"updating players", ^{

      it(@"checks for caught buckets after updating their positions", ^{
        [[machine stub] fire:any()];
        id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
        [[bomber stub] startAtSpeed:0.0 withBombs:0];
        [[bomber stubAndReturn:theValue(NO)] bombHit];
        [[bomber stubAndReturn:theValue(1)] droppedBombCount];
        [[bomber stubAndReturn:theValue(NO)] isOut];
        id buckets = [Buckets mock];
        [[buckets stubAndReturn:theValue(1)] bucketCount];

        kaboomContext.bomber = bomber;
        kaboomContext.buckets = buckets;

   //     [bomber setExpectationOrderMatters:YES];
        [[bomber expect] update:10];
        [[buckets expect] update:10];

        [[bomber expect] updateDroppedBombs:buckets];

        [kaboomContext updatePlayers:10];
      });

    });

    describe(@"ending a game", ^{

      it(@"will fire an end game when the user is out of buckets", ^{
        id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
        id buckets = [Buckets mock];
        kaboomContext.bomber = bomber;
        kaboomContext.buckets = buckets;

        [[bomber stubAndReturn:theValue(YES)] bombHit];
        [[bomber stub] update:10];
        [[bomber stub] updateDroppedBombs:buckets];
        [[bomber stub] explode];
        [[buckets stub] removeBucket];
        [[buckets stub] update:10.0];
        [[buckets stubAndReturn:theValue(0)] bucketCount];
        [[buckets stub] reset];

        [[machine expect] fire:@"End Game"];

        [kaboomContext updatePlayers:10];
      });
    });

    describe(@"bombs hitting", ^{

      it(@"starts exploding when a bomb hits", ^{
        id buckets = [Buckets mock];
        [[buckets stubAndReturn:theValue(1)] bucketCount];
        [[buckets stub] update:1];
        [[buckets stub] removeBucket];
        id bomber = [KWMock mockForProtocol:@protocol(Bomber)];
        [[bomber stubAndReturn:theValue(YES)] bombHit];
        [[bomber stub] update:1];
        [[bomber stub] updateDroppedBombs:buckets];
        [[bomber stub] explode];
        kaboomContext.bomber = bomber;
        kaboomContext.buckets = buckets;

        [[machine expect] fire:@"Bomb Hit"];

        [kaboomContext updatePlayers:1];
      });
    });
  });

SPEC_END