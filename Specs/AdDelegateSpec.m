#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "Director.h"
#import "AdDelegate.h"

OCDSpec2Context(AdDelegateSpec) {
  
  Describe(@"Delegate methods", ^{
    
    It(@"is created with a director", ^{
      id director = [OCMockObject mockForProtocol:@protocol(Director)];
      
      AdDelegate *del = [AdDelegate newWithDirector:director];
      
      [[director expect] resume];
      
      [del bannerViewActionDidFinish:nil];
      
    });
    
  });
  
}
