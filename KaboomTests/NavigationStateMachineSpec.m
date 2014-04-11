#import <Kiwi.h>
#import "NavigationStateMachine.h"
#import "KaboomStateMachine.h"

SPEC_BEGIN(NavigationStateMachineSpec)

describe(@"NavigationStateMachine", ^{
  
  it(@"can go to the credits", ^{
    id del = [KWMock mockForProtocol:@protocol(NavigationDelegate)];
    NavigationStateMachine *sm = [NavigationStateMachine newWithDelegate:del];
    [[del should] receive:@selector(displayCredits)];
    
    [sm showCredits];
  });
  
  it(@"can start the game", ^{
    id del = [KWMock mockForProtocol:@protocol(NavigationDelegate)];
    NavigationStateMachine *sm = [NavigationStateMachine newWithDelegate:del];
    
    [[del should] receive:@selector(displayGame)];
    
    [sm startGame];
  });
  
  it(@"can start the game if its already started", ^{
    id del = [KWMock mockForProtocol:@protocol(NavigationDelegate)];
    NavigationStateMachine *sm = [NavigationStateMachine newWithDelegate:del];
    
    [[del should] receive:@selector(displayGame) withCount:2];
    
    [sm startGame];
    [sm startGame];
  });
  
  it(@"will go from new game to credits", ^{
    id del = [KWMock mockForProtocol:@protocol(NavigationDelegate)];
    NavigationStateMachine *sm = [NavigationStateMachine newWithDelegate:del];
    [del stub:@selector(displayGame)];

    [[del should] receive:@selector(displayCredits)];

    [sm startGame];
    [sm showCredits];
  });
  
  it(@"will go from credits back to main menu", ^{
    id del = [KWMock mockForProtocol:@protocol(NavigationDelegate)];
    [del stub:@selector(displayCredits)];
    NavigationStateMachine *sm = [NavigationStateMachine newWithDelegate:del];
    
    [sm showCredits];
    
    [[del should] receive:@selector(hideCredits)];
    
    [sm closeCredits];
  });
  
  it(@"doesn't start the game when on credits screen", ^{
    id del = [KWMock mockForProtocol:@protocol(NavigationDelegate)];
    [del stub:@selector(displayCredits)];
    NavigationStateMachine *sm = [NavigationStateMachine newWithDelegate: del];
    [sm showCredits];
    
    [[theBlock(^{[sm startGame];}) should] raiseWithName:@"Invalid Transition"];
  });
  
  it(@"can sart the game after going from credits back to main menu", ^{
    id del = [KWMock mockForProtocol:@protocol(NavigationDelegate)];
    [del stub:@selector(displayCredits)];
    [del stub:@selector(hideCredits)];
    NavigationStateMachine *sm = [NavigationStateMachine newWithDelegate:del];
    
    [sm showCredits];
    [sm closeCredits];
    
    [[del should] receive:@selector(displayGame)];
    [sm startGame];
  });
  
  
});

SPEC_END
