#import <cocos2d/cocos2d.h>
#import "Bomber.h"

@interface BomberSprite : CCSprite

+(id) newSpriteWithBomber:(NSObject<Bomber> *) bomber;

@end