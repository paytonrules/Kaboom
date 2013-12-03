#import <GameKit/GameKit.h>
#import <cocos2d/cocos2d.h>

@class BombSprite;
@interface KaboomLayer : CCLayerColor <CCTouchOneByOneDelegate>
{
}

+(CCScene *) scene;
-(void) restartLevel;
-(void) explosionComplete;

@end
