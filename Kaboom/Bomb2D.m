#import "Bomb2D.h"

@implementation Bomb2D

@synthesize position;

+(id) bombAtX:(float) x y:(float) y
{
  Bomb2D *bomb = [Bomb2D new];
  bomb.position = CGPointMake(x, y);
  return bomb;
}

-(BOOL) hit {
  if (!CGRectIsEmpty(self.boundingBox)) {
    return self.boundingBox.origin.y <= 0;
  }
  return NO;
}


@end