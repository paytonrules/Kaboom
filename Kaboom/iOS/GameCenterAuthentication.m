#import <GameKit/GameKit.h>
#import <cocos2d/cocos2d.h>
#import "GameCenterAuthentication.h"
#import "CocosDirectorAdapter.h"


@interface GameCenterAuthentication()

@property(assign) BOOL userAuthenticated;

@end

@implementation GameCenterAuthentication

static GameCenterAuthentication *sharedHelper = nil;

+(instancetype) sharedInstance
{
  if (!sharedHelper) {
    sharedHelper = [GameCenterAuthentication new];
  }
  return sharedHelper;
}

-(id) init
{
  if ((self = [super init]))
  {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(authenticationChanged)
               name:GKPlayerAuthenticationDidChangeNotificationName
             object:nil];
    self.director = [CocosDirectorAdapter newWithCocosDirector:(CCDirectorIOS  *)[CCDirector sharedDirector]];
  }
  return self;
}

-(void) authenticationChanged
{
  if ([GKLocalPlayer localPlayer].authenticated && !self.userAuthenticated) {
    self.userAuthenticated = TRUE;
  } else if (![GKLocalPlayer localPlayer].authenticated && self.userAuthenticated) {
    self.userAuthenticated = FALSE;
  }
}

-(void) authenticateLocalUser
{
  [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController* vc, NSError *error) {
    if (vc != nil && [self.director supportsAuthentication]) {
      [self.director presentViewController:vc];
    }
  };
}

@end
