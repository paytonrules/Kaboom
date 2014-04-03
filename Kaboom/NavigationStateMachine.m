#import "NavigationStateMachine.h"
#import <TransitionKit/TransitionKit.h>

@interface NavigationStateMachine()

@property(strong) NSObject<NavigationDelegate> *del;

@property(strong) TKStateMachine *navigationSM;

@end

@implementation NavigationStateMachine

+(instancetype) newWithDelegate:(NSObject <NavigationDelegate> *)del {
  NavigationStateMachine *sm = [NavigationStateMachine new];
  sm.del = del;
  return sm;
}

-(instancetype) init {
  if (self = [super init]) {
    self.navigationSM = [TKStateMachine new];
    TKState *mainMenu = [TKState stateWithName:@"MainMenu"];
    TKState *game = [TKState stateWithName:@"Game"];
    
    [game setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
      [self.del displayGame];
    }];
    
    TKState *credits = [TKState stateWithName:@"Credits"];
    
    [credits setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
      [self.del displayCredits];
    }];
    [self.navigationSM addStates:@[mainMenu, game, credits]];
    
    TKEvent *startGame = [TKEvent eventWithName:@"StartGame" transitioningFromStates:@[ mainMenu ] toState:game];
    
    TKEvent *showCredits = [TKEvent eventWithName:@"ShowCredits"
                          transitioningFromStates:@[ mainMenu, game ]
                                          toState:credits];
    [self.navigationSM addEvents:@[startGame, showCredits]];
    
    [self.navigationSM activate];
  }
  return self;
}

-(void) showCredits
{
  [self.navigationSM fireEvent:@"ShowCredits" userInfo:nil error:nil];
}

-(void) startGame
{
  NSError *error = nil;
  [self.navigationSM fireEvent:@"StartGame" userInfo:nil error:&error];
  if (error != nil) {
    [NSException raise:@"Invalid Transition" format:nil];
  }  
}

-(void) closeCredits
{
  [self.del hideCredits];
}


@end