#import <cocos2d/cocos2d.h>
#import "ScaledSprite.h"
#import "Bomber.h"

@interface BomberSprite : ScaledSprite

+(id) newSpriteWithBomber:(NSObject<Bomber> *) bomber;

@end