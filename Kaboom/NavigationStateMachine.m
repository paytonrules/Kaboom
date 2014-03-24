#import "NavigationStateMachine.h"

@interface NavigationStateMachine()

@property(strong) NSObject<NavigationDelegate> *del;

@end

@implementation NavigationStateMachine

+(instancetype) newWithDelegate:(NSObject <NavigationDelegate> *)del {
  NavigationStateMachine *sm = [NavigationStateMachine new];
  sm.del = del;
  return sm;
}

-(void) showCredits {
  [self.del showCredits];
}


@end