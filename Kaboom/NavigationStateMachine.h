#import <Foundation/Foundation.h>

@protocol NavigationDelegate

-(void) showCredits;
@end

@interface NavigationStateMachine : NSObject

+(instancetype) newWithDelegate:(NSObject<NavigationDelegate> *) del;
-(void) showCredits;

@end