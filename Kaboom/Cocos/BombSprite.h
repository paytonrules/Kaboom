#import <cocos2d/cocos2d.h>
#import "Bomb.h"

@class BomberSprite;

@interface BombSprite : CCSprite

+(id) newSpriteWithBomb:(NSObject<Bomb> *) bomb;
-(void) blowUp:(BomberSprite *) bomber;
-(void) explosionComplete;

@end