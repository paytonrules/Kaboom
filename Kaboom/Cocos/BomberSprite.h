#import <cocos2d/cocos2d.h>
#import "Bomber.h"

@class BombSprite;

@interface BomberSprite : CCSprite

+(id) newSpriteWithBomber:(NSObject<Bomber> *) bomber;

@end