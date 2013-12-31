#import "Buckets.h"
#import "Bucket2D.h"

@interface Buckets ()

@property(assign) CGPoint position;
@property(assign) CGFloat speed;
@property(assign) CGFloat tilt;
@property(strong) NSMutableArray *theBuckets;
@property(assign) CGPoint originalPosition;

-(void) setupBuckets;

@end

@implementation Buckets

-(id) initWithPosition:(CGPoint) position speed:(CGFloat) speed
{
  if (self = [super init])
  {
    self.originalPosition = self.position = position;
    self.speed = speed;
    [self setupBuckets];
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

-(void) reset
{
  [self setupBuckets];
}

-(int) bucketCount
{
  return self.theBuckets.count;
}

-(void) setupBuckets
{
  self.position = self.originalPosition;
  self.theBuckets = [NSMutableArray arrayWithArray:@[
      [Bucket2D newBucketWithPosition:CGPointMake(self.position.x, self.position.y + 90)],
      [Bucket2D newBucketWithPosition:CGPointMake(self.position.x, self.position.y)],
      [Bucket2D newBucketWithPosition:CGPointMake(self.position.x, self.position.y - 90)]
  ]];
}
@end