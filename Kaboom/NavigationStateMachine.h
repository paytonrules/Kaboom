#import <Foundation/Foundation.h>
#import "KaboomStateMachine.h"
#import "NavigationDelegate.h"

@interface NavigationStateMachine : NSObject

+(instancetype) newWithDelegate:(NSObject<NavigationDelegate> *) del;

-(void) showCredits;
-(void) closeCredits;
-(void) startGame;

@end