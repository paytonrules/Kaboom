#import "ScaledSprite.h"
#import "Scaler.h"

@implementation ScaledSprite

-(Scaler *) scaler
{
  if (_scaler == nil)
  {
  _scaler = [Scaler new];
  }
  return _scaler;
}

@end