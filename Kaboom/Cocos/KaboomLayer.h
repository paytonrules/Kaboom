#import <GameKit/GameKit.h>
#import <cocos2d/cocos2d.h>

@interface KaboomLayer : CCLayerColor <CCTouchOneByOneDelegate>
{
}

+(CCScene *) scene;
-(void) restartLevel;

@end
