#import <cocos2d/cocos2d.h>

@class BombSprite;

@interface BombExplosion : CCParticleExplosion

+(id) newWithBombSprite:(BombSprite *) sprite;

@end