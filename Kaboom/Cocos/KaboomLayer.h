#import <GameKit/GameKit.h>
#import <cocos2d/cocos2d.h>

// KaboomLayer
@interface KaboomLayer : CCLayerColor <CCTouchOneByOneDelegate>
{
}

// returns a CCScene that contains the KaboomLayer as the only child
+(CCScene *) scene;

@end
