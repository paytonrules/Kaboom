#import <OCDSpec2/OCDSpec2.h>
#import "Bomb2D.h"
#import "Bucket2D.h"

OCDSpec2Context(Bucket2DSpec) {

  Describe(@"bucket caught Bomb", ^{
    It(@"Catches a bomb if it intersects with it", ^{
      NSObject<Bucket> *bucket =  [Bucket2D newBucketWithPosition:CGPointMake(0, 0)];
      ((Bucket2D *) bucket).boundingBox = CGRectMake(0, 0, 10, 10);

      Bomb2D *bomb = [Bomb2D new];
      bomb.boundingBox = CGRectMake(2, 2, 10, 10);

      [ExpectBool([bucket caughtBomb:bomb]) toBeTrue];
    });

    It(@"doesn't catch the bomb if it doesn't intersect with it", ^{
      NSObject<Bucket> *bucket =  [Bucket2D newBucketWithPosition:CGPointMake(0, 0)];
      ((Bucket2D *) bucket).boundingBox = CGRectMake(0, 0, 10, 10);

      Bomb2D *bomb = [Bomb2D new];
      bomb.boundingBox = CGRectMake(20, 20, 10, 10);

      [ExpectBool([bucket caughtBomb:bomb]) toBeFalse];
    });

    It(@"doesn't catch the bomb if it doesn't have a bounding box", ^{
      NSObject<Bucket> *bucket =  [Bucket2D newBucketWithPosition:CGPointMake(0, 0)];

      Bomb2D *bomb = [Bomb2D new];
      bomb.boundingBox = CGRectMake(0, 0, 10, 10);

      [ExpectBool([bucket caughtBomb:bomb]) toBeFalse];
    });

    It(@"starts as not removed", ^{
      NSObject<Bucket> *bucket =  [Bucket2D newBucketWithPosition:CGPointMake(0, 0)];

      [ExpectBool(bucket.removed) toBeFalse];
    });

    It(@"is removed on remove", ^{
      NSObject<Bucket> *bucket =  [Bucket2D newBucketWithPosition:CGPointMake(0, 0)];

      [bucket remove];

      [ExpectBool(bucket.removed) toBeTrue];
    });

    It(@"doesn't catch the bomb if it is removed", ^{
      Bucket2D *bucket =  [Bucket2D newBucketWithPosition:CGPointMake(0, 0)];
      bucket.boundingBox = CGRectMake(0, 0, 10, 10);
      [bucket remove];

      Bomb2D *bomb = [Bomb2D new];
      bomb.boundingBox = CGRectMake(2, 2, 10, 10);

      [ExpectBool([bucket caughtBomb:bomb]) toBeFalse];
    });
  });
}