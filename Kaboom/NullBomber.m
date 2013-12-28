#import "NullBomber.h"
#import "Buckets.h"

@implementation NullBomber

- (CGPoint)position {
  CGPoint result;
  return result;
}

- (int)bombCount {
  return 1;
}

- (NSArray *)bombs {
  return nil;
}

- (void)startAtSpeed:(float)speed withBombs:(int)count {

}

- (NSInteger)checkBombs:(Buckets *)buckets {
  return 0;
}

- (void)update:(float)deltaTime {

}

- (BOOL)bombHit {
  return NO;
}

- (void)explode {

}

- (BOOL)exploding {
  return NO;
}


@end