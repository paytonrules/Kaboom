#import <cocos2d/cocos2d.h>
#import "NavigationDelegate.h"

@interface MainMenuLayer : CCLayer<NavigationDelegate, UINavigationControllerDelegate>

+(CCScene *) scene;

@end
