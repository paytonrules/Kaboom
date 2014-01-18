#import "Scaler.h"
#import "SizeService.h"

const int GAME_WIDTH = 2048;
const int GAME_HEIGHT = 1536;

@interface Scaler()

@property(nonatomic, assign) CGSize viewToGameRatio;
@property(nonatomic, assign) CGSize gameToViewRatio;

@end

@implementation Scaler

-(CGSize) viewToGameRatio
{
  if (CGSizeEqualToSize(_viewToGameRatio, CGSizeZero))
  {
    CGSize winSize = [SizeService screenSize];
    _viewToGameRatio = CGSizeMake(winSize.width / GAME_WIDTH, winSize.height / GAME_HEIGHT);
  }
  return _viewToGameRatio;
}

-(CGSize) gameToViewRatio
{
  if (CGSizeEqualToSize(_gameToViewRatio, CGSizeZero))
  {
    CGSize winSize = [SizeService screenSize];
    _gameToViewRatio = CGSizeMake(GAME_WIDTH / winSize.width, GAME_HEIGHT / winSize.height);
  }
  return _gameToViewRatio;
}

-(CGPoint) gameToView:(CGPoint)point
{
  return CGPointMake(point.x * self.viewToGameRatio.width, point.y * self.viewToGameRatio.height);
}

-(CGPoint) viewToGame:(CGPoint)point
{
  return CGPointMake(point.x * self.gameToViewRatio.width, point.y * self.gameToViewRatio.height);
}
@end