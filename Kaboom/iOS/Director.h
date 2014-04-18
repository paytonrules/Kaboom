#import <Foundation/Foundation.h>

@class UIViewController;

@protocol Director <NSObject>

-(void) resume;
-(void) pause;
-(void) presentViewController:(UIViewController *) cont;
-(BOOL) supportsAuthentication;

@end
