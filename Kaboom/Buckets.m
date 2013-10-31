#import "Buckets.h"

const float kSpeed = 5.0;

@interface Buckets()

@property(assign) CGPoint position;
@property(assign) CGFloat speed;
@property(assign) CGFloat tilt;

@end

@implementation Buckets

-(id) initWithPosition:(CGPoint) position speed:(CGFloat) speed
{
  if (self = [super init])
  {
    self.position = position;
    self.speed = speed;
  }
  return self;

}

-(void) update:(CGFloat) deltaTime
{
  self.position = CGPointMake(self.position.x + (self.tilt * (self.speed / deltaTime)), self.position.y);
}

-(void) tilt:(float)angle
{
  self.tilt = angle;
}

-(BOOL) caughtBomb:(NSValue *)bomb
{
  return NO;
}
@end