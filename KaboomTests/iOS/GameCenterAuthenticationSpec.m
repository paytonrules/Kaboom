#import <Kiwi.h>
#import <GameKit/GameKit.h>
#import <cocos2d/cocos2d.h>
#import "GameCenterAuthentication.h"

SPEC_BEGIN(GameCenterAuthenticationSpec)

describe(@"Game Center Authentication", ^{
  beforeEach(^{
    [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController* vc, NSError *error){};
  });

  it(@"assigns the authenticate handler on authenticate local user", ^{
    GameCenterAuthentication *auth = [GameCenterAuthentication sharedInstance];
    
    [auth authenticateLocalUser];
    
    [[[GKLocalPlayer localPlayer].authenticateHandler should] beNonNil];
  });
  
  it(@"does nothing when the user already authenticated (view controller is nil", ^{
    GameCenterAuthentication *auth = [GameCenterAuthentication sharedInstance];
    
    [auth authenticateLocalUser];
    
    [[theBlock(^{ [GKLocalPlayer localPlayer].authenticateHandler(nil, nil); }) shouldNot] raise];
  });

});

SPEC_END