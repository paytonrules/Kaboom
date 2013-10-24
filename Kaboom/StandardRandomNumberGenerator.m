#import "StandardRandomNumberGenerator.h"

@implementation StandardRandomNumberGenerator

-(id) init
{
  if (self = [super init])
  {
    srand48(time(0));
  }
  return self;
}

-(float) generate
{
  return drand48();
}

@end