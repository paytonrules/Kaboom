#import <GameKit/GameKit.h>
#import <cocos2d/cocos2d.h>

// BombingLayer
@interface BombingLayer : CCLayerColor <CCTouchOneByOneDelegate>
{
}

// returns a CCScene that contains the BombingLayer as the only child
+(CCScene *) scene;

@end
