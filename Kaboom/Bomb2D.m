#import "Bomb2D.h"

@interface Bomb2D()
{
  int _height;
}
@end

@implementation Bomb2D

@synthesize position;

+(id) bombAtX:(float) x y:(float) y
{
  Bomb2D *bomb = [Bomb2D new];
  bomb.position = CGPointMake(x, y);
  return bomb;
}

-(int) height
{
  return _height;
}

-(void) setHeight:(int) height
{
  _height = height;
  self.position = CGPointMake(self.position.x, self.position.y - (height / 2));
}

-(BOOL) hit
{
  if (!CGRectIsEmpty(self.boundingBox)) // This is too low level
  {
    return self.boundingBox.origin.y <= 0;
  }
  return NO;
}


@end