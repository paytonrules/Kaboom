#import "cocos2d.h"

@class NavigationStateMachine;

@interface CreditsLayer : CCLayer
{
}

+(CCScene *) scene;
+(CCScene *) sceneWithMachine:(NavigationStateMachine *) sm;

@end
