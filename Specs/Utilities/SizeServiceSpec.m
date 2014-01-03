#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "SizeService.h"

OCDSpec2Context(SizeService) {

  Describe(@"The Size Service is a monostate strategy", ^{

    It(@"returns its size from its strategy", ^{
      id strategy = [OCMockObject mockForProtocol:@protocol(SizeStrategy)];

      [[[strategy stub] andReturnValue:[NSValue valueWithCGSize:CGSizeMake(20, 30)]] screenSize];

      [SizeService setStrategy:strategy];

      [ExpectFloat([SizeService screenSize].width) toBe:20 withPrecision:0.001];
      [ExpectFloat([SizeService screenSize].height) toBe:30 withPrecision:0.001];
    });

    It(@"returns 0, 0 if it hasn't been loaded", ^{
      [SizeService setStrategy:nil];

      [ExpectFloat([SizeService screenSize].width) toBe:0 withPrecision:0.001];
      [ExpectFloat([SizeService screenSize].height) toBe:0 withPrecision:0.001];
    });
  });
}
