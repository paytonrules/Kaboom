#import <Foundation/Foundation.h>
#import "KaboomStateMachine.h"

@protocol NavigationDelegate <NSObject>

-(void) displayCredits;
-(void) hideCredits;
-(void) displayGame;
@end
