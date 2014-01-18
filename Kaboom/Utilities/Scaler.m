#import "Scaler.h"
#import "SizeService.h"

@implementation Scaler

const int GAME_WIDTH = 2048;
const int GAME_HEIGHT = 1536;

+ (CGPoint)gameToView:(CGPoint)point
{
  CGSize winSize = [SizeService screenSize];
  return CGPointMake(point.x * winSize.width / GAME_WIDTH, point.y * winSize.height / GAME_HEIGHT);
}
@end