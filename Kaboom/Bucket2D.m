#import "Bucket2D.h"
#import "Bomb2D.h"

@interface Bucket2D()

@property(assign) BOOL removed;

@end

@implementation Bucket2D

+(id) newBucketWithPosition:(CGPoint)position
{
  Bucket2D *bucket = [Bucket2D new];
  bucket.position = position;
  return bucket;
}

-(id) init
{
  if (self = [super init])
  {
    self.removed = false;
  }
  return self;
}

-(BOOL)caughtBomb:(NSObject <Bomb> *)bomb
{
  return !CGRectIsEmpty(self.boundingBox) &&
      CGRectIntersectsRect(self.boundingBox, ((Bomb2D *) bomb).boundingBox);
}

-(void) remove
{
  self.removed = true;
}

@end