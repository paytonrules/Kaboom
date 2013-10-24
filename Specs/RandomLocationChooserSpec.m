#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "RandomLocationChooser.h"
#import "StandardRandomNumberGenerator.h"

OCDSpec2Context(RandomLocationChooser) {

  Describe(@"using the random number generator", ^{

    It(@"uses the random number generator for its next location", ^{
      id rand = [OCMockObject mockForProtocol:@protocol(RandomNumberGenerator)];
      NSRange range = NSMakeRange(0, 100);

      RandomLocationChooser *chooser = [RandomLocationChooser newChooserWithRange:range generator:rand];

      float retVal = 0.0;
      [[[rand stub] andReturnValue:OCMOCK_VALUE(retVal)] generate];

      [ExpectFloat([chooser next]) toBe:0.0 withPrecision:0.0001];
    });

    It(@"begins its range at the first value", ^{
      id rand = [OCMockObject mockForProtocol:@protocol(RandomNumberGenerator)];
      NSRange range = NSMakeRange(10, 100);

      RandomLocationChooser *chooser = [RandomLocationChooser newChooserWithRange:range generator:rand];

      float retVal = 0.0;
      [[[rand stub] andReturnValue:OCMOCK_VALUE(retVal)] generate];

      [ExpectFloat([chooser next]) toBe:10.0 withPrecision:0.0001];
    });

    It(@"Maxes out at the last value", ^{
      id rand = [OCMockObject mockForProtocol:@protocol(RandomNumberGenerator)];
      NSRange range = NSMakeRange(10, 110);

      RandomLocationChooser *chooser = [RandomLocationChooser newChooserWithRange:range generator:rand];

      float retVal = 1.0;
      [[[rand stub] andReturnValue:OCMOCK_VALUE(retVal)] generate];

      [ExpectFloat([chooser next]) toBe:120.0 withPrecision:0.0001];
    });

    It(@"is created with a default random number generator", ^{
      RandomLocationChooser *chooser = [RandomLocationChooser newChooserWithRange:NSMakeRange(0, 10)];

      [ExpectObj(chooser.rand) toBeKindOfClass:[StandardRandomNumberGenerator class]];

    });

  });
}
