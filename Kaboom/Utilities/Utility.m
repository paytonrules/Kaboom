#import "Utility.h"

@implementation Utility

+(CGSize) designSize
{
  return CGSizeMake(480, 320);
}

+(CGPoint)scalePoint:(CGPoint) point toDimensions :(CGSize)dimensions
{
  CGSize scaleFactor = CGSizeMake(dimensions.width / [self designSize].width,
                                  dimensions.height / [self designSize].height);

  return CGPointMake(point.x * scaleFactor.width, point.y * scaleFactor.height);
}
@end