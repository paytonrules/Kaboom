#import <OCDSpec2/OCDSpec2.h>
#import "Buckets.h"

OCDSpec2Context(BucketsSpec) {
  
  Describe(@"moving", ^{
    
    It(@"moves to the right", ^{
      Buckets *buckets = [[Buckets alloc] initWithPosition:CGPointMake(10.0, 10.0)];

      [buckets move:1];

      [ExpectFloat(buckets.position.x) toBe:11.0 withPrecision:0.00001];
    });

    It(@"moves to the left", ^{
      Buckets *buckets = [[Buckets alloc] initWithPosition:CGPointMake(10.0, 10.0)];

      [buckets move:-1.0];

      [ExpectFloat(buckets.position.x) toBe:9.0 withPrecision:0.00001];
    });
  });
  
}
