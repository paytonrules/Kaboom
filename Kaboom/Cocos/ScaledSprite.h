#import <cocos2d/cocos2d.h>

@class Scaler;

@interface ScaledSprite : CCSprite
{
  Scaler *_scaler;
}
@property(readonly) Scaler *scaler;

@end