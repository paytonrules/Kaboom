#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "Kaboom.h"
#import "KaboomPresenter.h"
#import "Bomb.h"
#import "GameBlackboard.h"
#import "Event.h"
#import "Buckets.h"

OCDSpec2Context(KaboomPresenter) {

  Describe(@"presentation", ^{

    It(@"delegates start to its game", ^{
      id game = [OCMockObject mockForClass:[Kaboom class]];
      KaboomPresenter *presenter = [KaboomPresenter newPresenterWithGame:game];

      [(KaboomPresenter *)[game expect] start];

      [presenter start];

      [game verify];
    });

    It(@"delegates update to its game", ^{
      id game = [OCMockObject mockForClass:[Kaboom class]];
      KaboomPresenter *presenter = [KaboomPresenter newPresenterWithGame:game];

      [[game expect] update:1.0];

      [presenter update:1.0];

      [game verify];
    });

    It(@"pauses updates when exploding", ^{
      id game = [OCMockObject mockForClass:[Kaboom class]];
      KaboomPresenter *presenter = [KaboomPresenter newPresenterWithGame:game];

      [presenter explosionStarted];
      [presenter update:1.0];

      [game verify];
    });

    It(@"delegates tilt through to the game", ^{
      id game = [OCMockObject mockForClass:[Kaboom class]];
      KaboomPresenter *presenter = [KaboomPresenter newPresenterWithGame:game];

      [[game expect] tilt:2.0];

      [presenter tilt:2.0];

      [game verify];
    });

  });

  Describe(@"bombs changing", ^{
    __block GameBlackboard *blackboard;

    BeforeEach(^{
      blackboard = [GameBlackboard sharedBlackboard];
      [blackboard clear];
    });

    It(@"stores an added bomb when the bomb dropped event happens", ^{
      id bomb = [OCMockObject mockForProtocol:@protocol(Bomb)];

      KaboomPresenter *presenter = [KaboomPresenter new];

      [blackboard notify:kBombDropped event:[Event newEventWithData:bomb]];

      [ExpectArray(presenter.createdBombs) toContain:bomb];
    });

    It(@"clears the added bombs on each update", ^{
      id bomb = [OCMockObject mockForProtocol:@protocol(Bomb)];

      KaboomPresenter *presenter = [KaboomPresenter new];

      [blackboard notify:kBombDropped event:[Event newEventWithData:bomb]];
      [presenter update:0];

      [ExpectInt(presenter.createdBombs.count) toBe:0];
    });
  });
}