#import <Foundation/Foundation.h>

@interface GameCenterAuthentication : NSObject

@property (assign, readonly) BOOL gameCenterAvailable;

+(instancetype) sharedInstance;
-(void) authenticateLocalUser;

@end
