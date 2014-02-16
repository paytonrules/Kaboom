#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import <iAd/iAd.h>

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate, ADBannerViewDelegate>
{
	UIWindow *window_;

	CCDirectorIOS	*__unsafe_unretained director_;							// weak ref
}

@property (nonatomic, strong) UIWindow *window;
@property (unsafe_unretained, readonly) CCDirectorIOS *director;

@end
