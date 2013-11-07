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
        [Bucket2D newBucketWithPosition:CGPointMake(position.x, position.y - 40)],
        [Bucket2D newBucketWithPosition:CGPointMake(position.x, position.y)],
        [Bucket2D newBucketWithPosition:CGPointMake(position.x, position.y + 40)]]];
  }
  return self;
}

-(NSArray *) buckets
{
  return [NSArray arrayWithArray:self.theBuckets];
}

-(void) update:(CGFloat) deltaTime
{
  CGPoint newLocation = CGPointMake(self.position.x + (self.tilt * (self.speed / deltaTime)), self.position.y);
  self.position = newLocation;

  for (Bucket2D *bucket in self.buckets)
  {
    bucket.position = newLocation;
  }
}

-(void) tilt:(float)angle
{
  self.tilt = angle;
}

-(BOOL) caughtBomb:(NSObject<Bomb> *)bomb
{
  for (Bucket2D *bucket in self.buckets) {
    if ([bucket caughtBomb:bomb])
      return YES;
  }

  return NO;
}
@end