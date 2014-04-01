#import <Foundation/Foundation.h>
#import "KaboomStateMachine.h"

@protocol NavigationDelegate

-(void) showCredits;
-(void) hideCredits;
@end

@interface NavigationStateMachine : NSObject

+(instancetype) newWithDelegate:(NSObject<NavigationDelegate> *) del;
+(instancetype) newWithGame:(NSObject<KaboomStateMachine> *) sm;
+(instancetype) newWithGame:(NSObject<KaboomStateMachine> *) sm delegate: (NSObject<NavigationDelegate> *) del;

-(void) showCredits;
-(void) closeCredits;
-(void) startGame;

@end