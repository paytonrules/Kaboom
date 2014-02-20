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

-(BOOL) bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
  [self.director pause];
  return YES;
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
  banner.hidden = YES;
}



@end
