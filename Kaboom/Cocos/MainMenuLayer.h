#import <cocos2d/cocos2d.h>
#import <GameKit/GKGameCenterViewController.h>
#import "NavigationDelegate.h"

@interface MainMenuLayer : CCLayer<NavigationDelegate, UINavigationControllerDelegate,
                                    GKGameCenterControllerDelegate>

+(CCScene *) scene;

@end
