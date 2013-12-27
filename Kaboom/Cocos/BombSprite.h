#import <cocos2d/cocos2d.h>
#import "Bomb.h"

FOUNDATION_EXPORT const int kBomb;

@class BomberSprite;

@interface BombSprite : CCSprite

@property(readonly) NSObject<Bomb> *bomb;
+(id) newSpriteWithBomb:(NSObject<Bomb> *) bomb;
-(void) explode;

@end