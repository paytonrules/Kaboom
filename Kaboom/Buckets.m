#import "Buckets.h"

@interface Buckets()

@property(assign) CGPoint position;

@end

@implementation Buckets

-(id) initWithPosition:(CGPoint) position
{
  if (self = [super init])
  {
    self.position = position;
  }
  return self;
}

-(void) move:(float) movement
{
  self.position = CGPointMake(self.position.x + movement, self.position.y);
}
@end