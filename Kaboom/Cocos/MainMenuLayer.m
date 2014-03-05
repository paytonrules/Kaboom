#import "MainMenuLayer.h"

@interface MainMenuLayer()
@property(strong) CCMenu *menu;

-(void) displayMainMenu;
@end

@implementation MainMenuLayer

// Boilerplate, boilerplate, does whatever a boiler can plate
+(CCScene *) scene {

  CCScene *scene = [CCScene node];

  // 'layer' is an autorelease object.
  MainMenuLayer *layer = [MainMenuLayer node];

  // add layer as a child to scene
  [scene addChild:layer];

  // return the scene
  return scene;
}

-(id)init
{
  if (self = [super init]) {
    CGSize screenSize = [CCDirector sharedDirector].winSize;

    CCSpriteBatchNode *gameArt;
    gameArt = [CCSpriteBatchNode batchNodeWithFile:@"game-sprites0.pvr.ccz"];
    [self addChild:gameArt];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"game-sprites0.plist"];

    CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"background-empty.png"];
    [background setPosition:ccp(screenSize.width / 2, screenSize.height / 2)];
    [self addChild:background];

    CCSprite *menuBackground = [CCSprite spriteWithSpriteFrameName:@"main-menu-background.png"];
    [menuBackground setPosition:ccp(screenSize.width / 2, screenSize.height / 2)];
    [self addChild:menuBackground];

    [self displayMainMenu];
  }
  return self;
}

-(void) displayMainMenu
{

}

@end