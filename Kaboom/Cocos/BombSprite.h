#import <cocos2d/cocos2d.h>
#import "Bomb.h"

FOUNDATION_EXPORT const int kBomb;

@class BomberSprite;

@interface BombSprite : CCSprite

+(id) newSpriteWithBomb:(NSObject<Bomb> *) bomb;
-(void) explosionComplete;
-(void) explode;

@end