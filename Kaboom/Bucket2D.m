#import "Bucket2D.h"

@interface Bucket2D()

@property(assign) CGPoint position;

@end

@implementation Bucket2D

+ (id)newBucketWithPosition:(CGPoint)position
{
  Bucket2D *bucket = [Bucket2D new];
  bucket.position = position;
  return bucket;
}

@end