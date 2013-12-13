#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "Kaboom.h"
#import "KaboomPresenter.h"
#import "Bomb.h"

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

  });

  Describe(@"bombs changing", ^{

    It(@"creates an added bomb when the bomber has a bomb", ^{
      id bomber = [OCMockObject mockForProtocol:@protocol(Bomber)];
      KaboomPresenter *presenter = [KaboomPresenter newPresenterWithBomber:bomber];

      id bomb = [OCMockObject mockForProtocol:@protocol(Bomb)];
      [[[bomber stub] andReturn:@[bomb]] bombs];

      [presenter update:1.0];

      [ExpectArray(presenter.createdBombs) toContain:bomb];
    });

    It(@"only creates an added bomb if the bomb is new", ^{
      id bomber = [OCMockObject mockForProtocol:@protocol(Bomber)];
      KaboomPresenter *presenter = [KaboomPresenter newPresenterWithBomber:bomber];

      id bomb = [OCMockObject mockForProtocol:@protocol(Bomb)];
      [[[bomber stub] andReturn:@[bomb]] bombs];

      [presenter update:1.0];
      [presenter update:1.0];

      [ExpectInt(presenter.createdBombs.count) toBe:0];
    });

  });
}