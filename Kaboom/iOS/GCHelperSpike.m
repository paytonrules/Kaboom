#import "GCHelperSpike.h"
#import <GameKit/GameKit.h>

@interface GCHelperSpike()

@property(assign) BOOL userAuthenticated;

@end

@implementation GCHelperSpike

static GCHelperSpike *sharedHelper = nil;

+(instancetype) sharedInstance
{
  if (!sharedHelper) {
    sharedHelper = [GCHelperSpike new];
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
  }
  return self;
}

-(void) authenticationChanged
{
  if ([GKLocalPlayer localPlayer].isAuthenticated && !self.userAuthenticated) {
    NSLog(@"Authentication changed: player authenticated.");
    self.userAuthenticated = TRUE;
  } else if (![GKLocalPlayer localPlayer].isAuthenticated && self.userAuthenticated) {
    NSLog(@"Authentication changed: player not authenticated");
    self.userAuthenticated = FALSE;
  }
}

-(void) authenticateLocalUser
{
  NSLog(@"Authenticating local user...");
  if ([GKLocalPlayer localPlayer].authenticated == NO) {
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
  } else {
    NSLog(@"Already authenticated!");
  }
}

@end
