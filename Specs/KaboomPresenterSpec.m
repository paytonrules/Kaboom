#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "Kaboom.h"
#import "KaboomPresenter.h"

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
}