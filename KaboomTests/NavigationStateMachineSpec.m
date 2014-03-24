#import <Kiwi.h>
#import "NavigationStateMachine.h"

SPEC_BEGIN(NavigationStateMachineSpec)

describe(@"NavigationStateMachine", ^{
  
  it(@"can go to the credits", ^{
    id del = [KWMock mockForProtocol:@protocol(NavigationDelegate)];
    NavigationStateMachine *sm = [NavigationStateMachine newWithDelegate:del];
    [[del should] receive:@selector(showCredits)];
    
    [sm showCredits];
  });
  
});

SPEC_END
