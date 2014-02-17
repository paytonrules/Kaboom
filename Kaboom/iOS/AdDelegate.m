#import <iAd/iAd.h>
#import "AdDelegate.h"

@interface AdDelegate ()
@property(strong) NSObject<Director> *director;
@end

@implementation AdDelegate

+(instancetype) newWithDirector:(NSObject<Director> *) director
{
  AdDelegate *del = [AdDelegate new];
  del.director = director;
  return del;
}

-(void) bannerViewActionDidFinish:(ADBannerView *)banner
{
  [self.director resume];
}


@end
