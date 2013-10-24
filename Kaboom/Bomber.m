#import "Bomber.h"

@interface Bomber()
@property(assign) CGPoint position;
@property(assign) float speed;
@property(strong) NSObject<LocationChooser> *locations;
@property(assign) float location;
@property(assign) BOOL started;
@end

@implementation Bomber

-(id)initWithPosition:(CGPoint)position speed:(float)speed locationChooser:(NSObject <LocationChooser> *)locations
{
  if (self = [super init])
  {
    self.position = position;
    self.speed = speed;
    self.locations = locations;
  }
  return self;
}

- (void)start
{
  self.location = [self.locations next];
  self.started = YES;
}

- (void)update:(float)deltaTime
{
  if (self.started)
  {
    float moveDistance = self.speed * deltaTime;
    float distanceRemaining = abs(self.location - self.position.x);

    if (self.location > self.position.x) {
      self.position = CGPointMake(self.position.x + moveDistance, self.position.y);
    }
    else {
      self.position = CGPointMake(self.position.x - moveDistance, self.position.y);
    }

    if (moveDistance >= distanceRemaining) {
      self.location = [self.locations next];
    }
  }
}
@end