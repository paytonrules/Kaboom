#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "Scaler.h"
#import "SizeService.h"

OCDSpec2Context(Scaler) {

  Describe(@"Scaling game positions by resolution", ^{
    __block Scaler *scaler;

    BeforeEach(^{
      scaler = [Scaler new];
    });

    It(@"Goes from game coordinates to view coordinates using the size strategy", ^{
      id sizeStrategy = [OCMockObject mockForProtocol:@protocol(SizeStrategy)];
      CGSize screenSize = CGSizeMake(1024, 768);
      [[[sizeStrategy stub] andReturnValue:[NSValue valueWithCGSize:screenSize]] screenSize];
      [SizeService setStrategy:sizeStrategy];

      CGPoint position = CGPointMake(10, 20);

      CGPoint viewPosition = [scaler gameToView:position];

      [ExpectInt(viewPosition.x) toBe:5];
      [ExpectInt(viewPosition.y) toBe:10];
    });

    // Write another validating the game resolution
    It(@"Makes no translation if the view is the same size as the game", ^{
      id sizeStrategy = [OCMockObject mockForProtocol:@protocol(SizeStrategy)];
      CGSize screenSize = CGSizeMake(1024 * 2, 768 * 2);
      [[[sizeStrategy stub] andReturnValue:[NSValue valueWithCGSize:screenSize]] screenSize];
      [SizeService setStrategy:sizeStrategy];

      CGPoint position = CGPointMake(10, 20);

      CGPoint viewPosition = [scaler gameToView:position];

      [ExpectInt(viewPosition.x) toBe:10];
      [ExpectInt(viewPosition.y) toBe:20];
    });

    It(@"also goes from view to game", ^{
      id sizeStrategy = [OCMockObject mockForProtocol:@protocol(SizeStrategy)];
      CGSize screenSize = CGSizeMake(1024, 768);
      [[[sizeStrategy stub] andReturnValue:[NSValue valueWithCGSize:screenSize]] screenSize];
      [SizeService setStrategy:sizeStrategy];

      CGPoint position = CGPointMake(10, 20);

      CGPoint gamePosition = [scaler viewToGame:position];

      [ExpectInt(gamePosition.x) toBe:20];
      [ExpectInt(gamePosition.y) toBe:40];
    });

  });
}