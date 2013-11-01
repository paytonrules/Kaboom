#import <OCDSpec2/OCDSpec2.h>
#import "Buckets2D.h"
#import "Bomb2D.h"

OCDSpec2Context(Buckets2DSpec) {
  
  Describe(@"moving", ^{
    
    It(@"slides to the right when the screen is tilted in a positive direction", ^{
      Buckets2D *buckets = [[Buckets2D alloc] initWithPosition:CGPointMake(10.0, 10.0) speed:1.0];

      [buckets tilt:1.0];
      [buckets update:1.0];

      [ExpectFloat(buckets.position.x) toBe:11.0 withPrecision:0.00001];
    });

    It(@"slides at the passed in speed per second", ^{
      Buckets2D *buckets = [[Buckets2D alloc] initWithPosition:CGPointMake(10.0, 10.0) speed:1.0];

      [buckets tilt:1.0];
      [buckets update:2.0];

      [ExpectFloat(buckets.position.x) toBe:10.5 withPrecision:0.00001];
    });

    It(@"continues sliding on each update", ^{
      Buckets2D *buckets = [[Buckets2D alloc] initWithPosition:CGPointMake(10.0, 10.0) speed:1.0];

      [buckets tilt:1.0];
      [buckets update:2.0];
      [buckets update:2.0];

      [ExpectFloat(buckets.position.x) toBe:11.0 withPrecision:0.00001];
    });

    It(@"moves to the left when the tilt is negative", ^{
      Buckets2D *buckets = [[Buckets2D alloc] initWithPosition:CGPointMake(10.0, 10.0) speed:1.0];

      [buckets tilt:-1.0];
      [buckets update:1.0];

      [ExpectFloat(buckets.position.x) toBe:9.0 withPrecision:0.00001];
    });

    It(@"is tilted a percentage, so 0.5 should only move half the speed", ^{
      Buckets2D *buckets = [[Buckets2D alloc] initWithPosition:CGPointMake(10.0, 10.0) speed:1.0];

      [buckets tilt:-0.5];
      [buckets update:1.0];

      [ExpectFloat(buckets.position.x) toBe:9.5 withPrecision:0.00001];
    });
  });

  Describe(@"catching bombs", ^{

    It(@"Catches a bomb if it intersects with the buckets", ^{
      Buckets2D *bucket =  [[Buckets2D alloc] initWithPosition:CGPointMake(0, 0) speed:1.0];
      bucket.boundingBox = CGRectMake(0, 0, 10, 10);

      Bomb2D *bomb = [Bomb2D new];
      bomb.boundingBox = CGRectMake(2, 2, 10, 10);

      [ExpectBool([bucket caughtBomb:bomb]) toBeTrue];
    });

    It(@"doesn't catch the bomb if the bounding boxes don't intersect", ^{
      Buckets2D *bucket =  [[Buckets2D alloc] initWithPosition:CGPointMake(0, 0) speed:1.0];
      bucket.boundingBox = CGRectMake(0, 0, 10, 10);

      Bomb2D *bomb = [Bomb2D new];
      bomb.boundingBox = CGRectMake(20, 20, 10, 10);

      [ExpectBool([bucket caughtBomb:bomb]) toBeFalse];
    });

  });
}
