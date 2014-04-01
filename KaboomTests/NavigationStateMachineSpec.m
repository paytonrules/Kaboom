#import <Kiwi.h>
#import "NavigationStateMachine.h"
#import "KaboomStateMachine.h"

SPEC_BEGIN(NavigationStateMachineSpec)

describe(@"NavigationStateMachine", ^{
  
  it(@"can go to the credits", ^{
    id del = [KWMock mockForProtocol:@protocol(NavigationDelegate)];
    NavigationStateMachine *sm = [NavigationStateMachine newWithDelegate:del];
    [[del should] receive:@selector(showCredits)];
    
    [sm showCredits];
  });
  
  it(@"can go to the new game", ^{
    id gameStateMachine = [KWMock mockForProtocol:@protocol(KaboomStateMachine)];
    NavigationStateMachine *sm = [NavigationStateMachine newWithGame:gameStateMachine];
    
    [[gameStateMachine should] receive:@selector(start)];
    
    [sm startGame];
  });
  
  it(@"will go from new game to credits", ^{
    id gameStateMachine = [KWMock mockForProtocol:@protocol(KaboomStateMachine)];
    id del = [KWMock mockForProtocol:@protocol(NavigationDelegate)];
    NavigationStateMachine *sm = [NavigationStateMachine newWithGame:gameStateMachine
                                                            delegate: del];

    [[del should] receive:@selector(showCredits)];
    
    [sm showCredits];
  });
  
  it(@"will go from credits back to main menu", ^{
    id gameStateMachine = [KWMock mockForProtocol:@protocol(KaboomStateMachine)];
    id del = [KWMock mockForProtocol:@protocol(NavigationDelegate)];
    [del stub:@selector(showCredits)];
    NavigationStateMachine *sm = [NavigationStateMachine newWithGame:gameStateMachine
                                                            delegate: del];
    
    [sm showCredits];
    
    [[del should] receive:@selector(hideCredits)];
    
    [sm closeCredits];
  });
  
  it(@"doesn't start the game when on credits screen", ^{
    id gameStateMachine = [KWMock mockForProtocol:@protocol(KaboomStateMachine)];
    id del = [KWMock mockForProtocol:@protocol(NavigationDelegate)];
    [del stub:@selector(showCredits)];
    NavigationStateMachine *sm = [NavigationStateMachine newWithGame:gameStateMachine
                                                              delegate: del];
    [sm showCredits];
    
    [[theBlock(^{[sm startGame];}) should] raiseWithName:@"Invalid Transition"];
  });
  
  
});

SPEC_END
