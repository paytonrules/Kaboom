#import "SizeService.h"

static NSObject<SizeStrategy> *theStrategy = nil;

@implementation SizeService

+(void) setStrategy:(NSObject <SizeStrategy> *)strategy
{
  theStrategy = strategy;
}

+ (CGSize)screenSize
{
  return [theStrategy screenSize];
}

@end
