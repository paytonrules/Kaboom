#import <Foundation/Foundation.h>

@protocol NavigationDelegate
@end

@interface NavigationStateMachine : NSObject

+(instancetype) newWithDelegate:(NSObject<NavigationDelegate> *) del;

@end