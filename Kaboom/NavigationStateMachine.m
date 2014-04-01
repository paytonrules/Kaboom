#import "NavigationStateMachine.h"
#import <TransitionKit/TransitionKit.h>

@interface NavigationStateMachine()

@property(strong) NSObject<NavigationDelegate> *del;
@property(strong) NSObject<KaboomStateMachine> *game;

@property(strong) TKStateMachine *navigationSM;

@end

@implementation NavigationStateMachine

+(instancetype) newWithDelegate:(NSObject <NavigationDelegate> *)del {
  return [NavigationStateMachine newWithGame:nil delegate:del];}

+(instancetype) newWithGame:(NSObject <KaboomStateMachine> *)game {
  return [NavigationStateMachine newWithGame:game delegate:nil];
}

+(instancetype) newWithGame:(NSObject<KaboomStateMachine> *)game delegate:(NSObject<NavigationDelegate> *)del {
  NavigationStateMachine *sm = [NavigationStateMachine new];
  sm.game = game;
  sm.del = del;
  return sm;
}

-(instancetype) init {
  if (self = [super init]) {
    self.navigationSM = [TKStateMachine new];
    TKState *mainMenu = [TKState stateWithName:@"MainMenu"];
    TKState *game = [TKState stateWithName:@"Game"];
    TKState *credits = [TKState stateWithName:@"Credits"];
    [self.navigationSM addStates:@[mainMenu, game, credits]];
    
    TKEvent *startGame = [TKEvent eventWithName:@"StartGame" transitioningFromStates:@[ mainMenu ] toState:game];
    
    TKEvent *showCredits = [TKEvent eventWithName:@"ShowCredits" transitioningFromStates:@[ mainMenu ] toState:credits];
    [self.navigationSM addEvents:@[startGame, showCredits]];
    
    
    [self.navigationSM activate];
    
  }
  return self;
}

-(void) showCredits {
  [self.navigationSM fireEvent:@"ShowCredits" userInfo:nil error:nil];
  [self.del showCredits];
}

-(void) startGame {
  NSError *error = nil;
  [self.navigationSM fireEvent:@"StartGame" userInfo:nil error:&error];
  if (error == nil) {
    [self.game start];
  } else {
    [NSException raise:@"Invalid Transition" format:nil];
  }
  
}

-(void) closeCredits {
  [self.del hideCredits];
}


@end