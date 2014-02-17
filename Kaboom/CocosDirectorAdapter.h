#import <UIKit/UIKit.h>
#import "Director.h"

@class CCDirectorIOS;

@interface CocosDirectorAdapter : NSObject<Director>

+(instancetype) newWithCocosDirector:(CCDirectorIOS *)director;

@end
