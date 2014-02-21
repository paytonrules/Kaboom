#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "Director.h"
#import "AdDelegate.h"

OCDSpec2Context(AdDelegateSpec) {
  
  Describe(@"Delegate methods", ^{
    
    It(@"resumes the director when the view action finished", ^{
      id director = [OCMockObject mockForProtocol:@protocol(Director)];
      
      AdDelegate *del = [AdDelegate newWithDirector:director];
      
      [[director expect] resume];
      
      [del bannerViewActionDidFinish:nil];
    });

    It(@"pauses the director when the view action begins", ^{
      id director = [OCMockObject mockForProtocol:@protocol(Director)];

      AdDelegate *del = [AdDelegate newWithDirector:director];

      [[director expect] pause];

      [del bannerViewActionShouldBegin:nil willLeaveApplication:NO];

      [director verify];
    });

    It(@"Allows the banner add to begin", ^{
      id director = [OCMockObject niceMockForProtocol:@protocol(Director)];

      AdDelegate *del = [AdDelegate newWithDirector:director];

      [ExpectBool([del bannerViewActionShouldBegin:nil willLeaveApplication:NO]) toBeTrue];
    });

    It(@"hides the ad when there are errors", ^{
      id view = [OCMockObject mockForClass:[ADBannerView class]]; // ADBannerView dies on instantiation. Fucker.
      id director = [OCMockObject niceMockForProtocol:@protocol(Director)];

      AdDelegate *del = [AdDelegate newWithDirector:director];

      [[view expect] setHidden:YES]; // Fucking lame

      [del bannerView:view didFailToReceiveAdWithError:nil];

      [view verify];
    });

    It(@"shows the ad when an ad is ready", ^{
      id view = [OCMockObject mockForClass:[ADBannerView class]]; // ADBannerView dies on instantiation. Fucker.
      id director = [OCMockObject niceMockForProtocol:@protocol(Director)];

      AdDelegate *del = [AdDelegate newWithDirector:director];

      [[view expect] setHidden:NO]; // Fucking lame - both times

      [del bannerViewWillLoadAd:view];

      [view verify];

    });
  });
  
}
