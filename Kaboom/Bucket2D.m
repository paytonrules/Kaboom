#import "Bucket2D.h"
#import "Bomb2D.h"

@implementation Bucket2D

+(id) newBucketWithPosition:(CGPoint)position
{
  Bucket2D *bucket = [Bucket2D new];
  bucket.position = position;
  return bucket;
}

-(BOOL)caughtBomb:(NSObject <Bomb> *)bomb
{
  return !CGRectIsEmpty(self.boundingBox) &&
      CGRectIntersectsRect(self.boundingBox, ((Bomb2D *) bomb).boundingBox);
}

@end