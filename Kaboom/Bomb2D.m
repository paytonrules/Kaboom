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
  return self.boundingBox.origin.y - self.boundingBox.size.height < 0;
}


@end