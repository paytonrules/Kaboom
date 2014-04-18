#import <Kiwi.h>
#import <GameKit/GameKit.h>
#import <cocos2d/cocos2d.h>
#import "GameCenterAuthentication.h"
#import "Director.h"

SPEC_BEGIN(GameCenterAuthenticationSpec)

describe(@"Game Center Authentication", ^{
  beforeEach(^{
    [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController* vc, NSError *error){};
  });
  
  it(@"has a shared istance", ^{
    GameCenterAuthentication *authOne = [GameCenterAuthentication sharedInstance];
    GameCenterAuthentication *authTwo = [GameCenterAuthentication sharedInstance];
    
    [[authOne shouldNot] beNil];
    [[authTwo should] beIdenticalTo:authOne];
    
  });

  it(@"assigns the authenticate handler on authenticate local user", ^{
    GameCenterAuthentication *auth = [GameCenterAuthentication new];
    
    [auth authenticateLocalUser];
    
    [[[GKLocalPlayer localPlayer].authenticateHandler should] beNonNil];
  });
  
  it(@"does nothing when the user already authenticated (view controller is nil", ^{
    GameCenterAuthentication *auth = [GameCenterAuthentication new];
    
    [auth authenticateLocalUser];
    
    [[theBlock(^{ [GKLocalPlayer localPlayer].authenticateHandler(nil, nil); }) shouldNot] raise];
  });
  
  it(@"presents the passed in view controller in the authenticate handler", ^{
    id director = [KWMock mockForProtocol:@protocol(Director)];
    id viewController = [UIViewController new];
    GameCenterAuthentication *auth = [GameCenterAuthentication new];
    auth.director = director;
    
      [[director stubAndReturn:theValue(YES)] supportsAuthentication];
    [auth authenticateLocalUser];
    
    [[[director should] receive] presentViewController:viewController];
    [GKLocalPlayer localPlayer].authenticateHandler(viewController, nil);
  });
  
  it(@"doesnt present the view controller if it is not allowed", ^{
    id director = [KWMock mockForProtocol:@protocol(Director)];
    id viewController = [UIViewController new];
    GameCenterAuthentication *auth = [GameCenterAuthentication new];
    auth.director = director;
    
    [[director stubAndReturn:theValue(NO)] supportsAuthentication];
    [auth authenticateLocalUser];
    
    [[[director shouldNot] receive] presentViewController:viewController];
    [GKLocalPlayer localPlayer].authenticateHandler(viewController, nil);
  });

});

SPEC_END