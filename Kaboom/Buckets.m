#import "Buckets.h"
#import "Bucket2D.h"
#import <Underscore.m/Underscore.h>

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
    self.theBuckets = [NSMutableArray arrayWithArray:@[
        [Bucket2D new],
        [Bucket2D new],
        [Bucket2D new]]];
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
    int lastBucket = [self bucketCount] - 1;
    NSObject<Bucket> *bucket = self.theBuckets[lastBucket];
    [bucket remove];
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
  self.position = self.originalPosition;
  [self setupBuckets];
}

-(int) bucketCount
{
  NSArray *availableBuckets = Underscore.filter(self.theBuckets, ^BOOL (NSObject<Bucket> *bucket) {
    return !bucket.removed;
  });
  return availableBuckets.count;
}

-(void) setupBuckets
{
  ((NSObject<Bucket> *) self.theBuckets[0]).position = CGPointMake(self.originalPosition.x, self.originalPosition.y + 90);
  ((NSObject<Bucket> *) self.theBuckets[1]).position = CGPointMake(self.originalPosition.x, self.originalPosition.y);
  ((NSObject<Bucket> *) self.theBuckets[2]).position = CGPointMake(self.originalPosition.x, self.originalPosition.y - 90);
  for (NSObject<Bucket> *bucket in self.theBuckets ) {
    [bucket putBack];
  }
}
@end