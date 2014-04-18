#import <Foundation/Foundation.h>
#import "Director.h"

@interface GameCenterAuthentication : NSObject

@property (assign, readonly) BOOL gameCenterAvailable;
@property (strong) NSObject<Director> *director;

+(instancetype) sharedInstance;
-(void) authenticateLocalUser;

@end
