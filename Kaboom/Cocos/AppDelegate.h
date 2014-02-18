#import <UIKit/UIKit.h>
#import <cocos2d/cocos2d.h>

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;

	CCDirectorIOS	*__unsafe_unretained director_;							// weak ref
}

@property (nonatomic, strong) UIWindow *window;
@property (unsafe_unretained, readonly) CCDirectorIOS *director;

@end
