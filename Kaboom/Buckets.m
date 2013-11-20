#import "Buckets.h"
#import "Bomb2D.h"
#import "Bucket2D.h"

@interface Buckets ()

@property(assign) CGPoint position;
@property(assign) CGFloat speed;
@property(assign) CGFloat tilt;
@property(strong) NSMutableArray *theBuckets;

@end

@implementation Buckets

-(id) initWithPosition:(CGPoint) position speed:(CGFloat) speed
{
  if (self = [super init])
  {
    self.position = position;
    self.speed = speed;
    self.theBuckets = [NSMutableArray arrayWithArray:@[
        [Bucket2D newBucketWithPosition:CGPointMake(position.x, position.y + 90)],
        [Bucket2D newBucketWithPosition:CGPointMake(position.x, position.y)],
        [Bucket2D newBucketWithPosition:CGPointMake(position.x, position.y - 90)]
        ]];
  }
  return self;
}

-(NSArray *) buckets
{
  return [NSArray arrayWithArray:self.theBuckets];
}

-(void) update:(CGFloat) deltaTime
{
  float newX = self.position.x + (self.tilt * (self.speed / deltaTime));
  self.position = CGPointMake(newX, self.position.y);

  for (Bucket2D *bucket in self.buckets)
  {
    bucket.position = CGPointMake(newX, bucket.position.y);
  }
}

-(void) tilt:(float)angle
{
  self.tilt = angle;
}

-(void) removeBucket
{
  if ([self bucketCount] != 0)
  {
    int lastBucket = self.theBuckets.count - 1;
    NSObject<Bucket> *bucket = self.theBuckets[lastBucket];
    [bucket remove];
    [self.theBuckets removeObjectAtIndex:lastBucket];
  }
}

-(BOOL) caughtBomb:(NSObject<Bomb> *)bomb
{
  for (Bucket2D *bucket in self.buckets) {
    if ([bucket caughtBomb:bomb])
      return YES;
  }

  return NO;
}

-(int) bucketCount
{
  return self.theBuckets.count;
}
@end