#import <cocos2d/cocos2d.h>
#import "Bomb.h"

@interface BombSprite : CCSprite

+(id) newSpriteWithBomb:(NSObject<Bomb> *) bomb;

@end