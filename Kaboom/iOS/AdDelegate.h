#import <Foundation/Foundation.h>
#import <iAd/iAd.h>
#import "Director.h"

@protocol ADBannerViewDelegate;

@interface AdDelegate : NSObject<ADBannerViewDelegate>

+(instancetype) newWithDirector:(NSObject<Director> *) director;

@end
