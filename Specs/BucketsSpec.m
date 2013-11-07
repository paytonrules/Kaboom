#import <OCDSpec2/OCDSpec2.h>
#import "Buckets.h"
#import "Bomb2D.h"
#import "Bucket.h"
#import "Bucket2D.h"

OCDSpec2Context(BucketsSpec) {

  Describe(@"initializing buckets", ^{

    It(@"starts with three buckets", ^{
      Buckets *buckets = [[Buckets alloc] initWithPosition:CGPointMake(0, 0) speed:0];

      [ExpectInt(buckets.buckets.count) toBe:3];
    });

    It(@"positions the buckets relative to the position", ^{
      Buckets *buckets = [[Buckets alloc] initWithPosition:CGPointMake(10, 40) speed:0];

      NSObject<Bucket> *bucket = buckets.buckets[0];
      [ExpectInt(bucket.position.x) toBe:10];
      [ExpectInt(bucket.position.y) toBe:0];

      bucket = buckets.buckets[1];
      [ExpectInt(bucket.position.x) toBe:10];
      [ExpectInt(bucket.position.y) toBe:40];

      bucket = buckets.buckets[2];
      [ExpectInt(bucket.position.x) toBe:10];
      [ExpectInt(bucket.position.y) toBe:80];
    });

  });
  
  Describe(@"moving", ^{
    
    It(@"slides to the right when the screen is tilted in a positive direction", ^{
      Buckets *buckets = [[Buckets alloc] initWithPosition:CGPointMake(10.0, 10.0) speed:1.0];

      [buckets tilt:1.0];
      [buckets update:1.0];

      [ExpectFloat(buckets.position.x) toBe:11.0 withPrecision:0.00001];
    });

    It(@"slides at the passed in speed per second", ^{
      Buckets *buckets = [[Buckets alloc] initWithPosition:CGPointMake(10.0, 10.0) speed:1.0];

      [buckets tilt:1.0];
      [buckets update:2.0];

      [ExpectFloat(buckets.position.x) toBe:10.5 withPrecision:0.00001];
    });

    It(@"continues sliding on each update", ^{
      Buckets *buckets = [[Buckets alloc] initWithPosition:CGPointMake(10.0, 10.0) speed:1.0];

      [buckets tilt:1.0];
      [buckets update:2.0];
      [buckets update:2.0];

      [ExpectFloat(buckets.position.x) toBe:11.0 withPrecision:0.00001];
    });

    It(@"moves to the left when the tilt is negative", ^{
      Buckets *buckets = [[Buckets alloc] initWithPosition:CGPointMake(10.0, 10.0) speed:1.0];

      [buckets tilt:-1.0];
      [buckets update:1.0];

      [ExpectFloat(buckets.position.x) toBe:9.0 withPrecision:0.00001];
    });

    It(@"is tilted a percentage, so 0.5 should only move half the speed", ^{
      Buckets *buckets = [[Buckets alloc] initWithPosition:CGPointMake(10.0, 10.0) speed:1.0];

      [buckets tilt:-0.5];
      [buckets update:1.0];

      [ExpectFloat(buckets.position.x) toBe:9.5 withPrecision:0.00001];
    });

    It(@"moves its buckets", ^{
      Buckets *buckets = [[Buckets alloc] initWithPosition:CGPointMake(10.0, 10.0) speed:1.0];

      [buckets tilt:-0.5];
      [buckets update:1.0];

      NSObject<Bucket> *bucket = buckets.buckets[0];
      [ExpectFloat(bucket.position.x) toBe:9.5 withPrecision:0.00001];
      bucket = buckets.buckets[1];
      [ExpectFloat(bucket.position.x) toBe:9.5 withPrecision:0.00001];
      bucket = buckets.buckets[2];
      [ExpectFloat(bucket.position.x) toBe:9.5 withPrecision:0.00001];
    });
  });

  Describe(@"catching bombs", ^{

    It(@"Catches a bomb if it intersects with it's first bucket", ^{
      Buckets *buckets =  [[Buckets alloc] initWithPosition:CGPointMake(0, 0) speed:1.0];
      ((Bucket2D *) buckets.buckets[0]).boundingBox = CGRectMake(0, 0, 10, 10);

      Bomb2D *bomb = [Bomb2D new];
      bomb.boundingBox = CGRectMake(2, 2, 10, 10);

      [ExpectBool([buckets caughtBomb:bomb]) toBeTrue];
    });

    It(@"Catches a bomb if it intersects with it's second bucket", ^{
      Buckets *buckets =  [[Buckets alloc] initWithPosition:CGPointMake(0, 0) speed:1.0];
      ((Bucket2D *) buckets.buckets[1]).boundingBox = CGRectMake(0, 0, 10, 10);

      Bomb2D *bomb = [Bomb2D new];
      bomb.boundingBox = CGRectMake(2, 2, 10, 10);

      [ExpectBool([buckets caughtBomb:bomb]) toBeTrue];
    });

    It(@"Catches a bomb if it intersects with it's third bucket", ^{
      Buckets *buckets =  [[Buckets alloc] initWithPosition:CGPointMake(0, 0) speed:1.0];
      ((Bucket2D *) buckets.buckets[2]).boundingBox = CGRectMake(0, 0, 10, 10);

      Bomb2D *bomb = [Bomb2D new];
      bomb.boundingBox = CGRectMake(2, 2, 10, 10);

      [ExpectBool([buckets caughtBomb:bomb]) toBeTrue];
    });

    It(@"doesn't catch the bomb if it doesn't intersect with any buckets bounding boxes", ^{
      Buckets *buckets =  [[Buckets alloc] initWithPosition:CGPointMake(0, 0) speed:1.0];
      for (Bucket2D *bucket in buckets.buckets)
      {
        bucket.boundingBox = CGRectMake(0, 0, 10, 10);
      }

      Bomb2D *bomb = [Bomb2D new];
      bomb.boundingBox = CGRectMake(20, 20, 10, 10);

      [ExpectBool([buckets caughtBomb:bomb]) toBeFalse];
    });
  });
}
