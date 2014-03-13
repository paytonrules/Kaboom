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
  CGSize screenSize = [CCDirector sharedDirector].winSize;

  CCLabelTTF *newGameLabel = [CCLabelTTF labelWithString:@"New Game" fontName:@"Helvetica" fontSize:42];
  CCMenuItemLabel *newGame = [CCMenuItemLabel itemWithLabel:newGameLabel target:self selector:@selector(newGame:)];
  [newGame setPosition:ccp(screenSize.width * 3 / 4, screenSize.height / 2 - (newGame.boundingBox.size.height))];

  CCLabelTTF *creditsLabel = [CCLabelTTF labelWithString:@"Credits" fontName:@"Helvetica" fontSize:42];
  CCMenuItemLabel *credits = [CCMenuItemLabel itemWithLabel:creditsLabel target:self selector:@selector(showCredits:)];
  float y = (screenSize.height / 2)  - (newGame.boundingBox.size.height * 1.5) - credits.boundingBox.size.height;
  [credits setPosition:ccp(screenSize.width * 3 / 4, y)];

  CCMenu *newGameMenu = [CCMenu menuWithItems:newGame, credits, nil];
  newGameMenu.visible = YES;
  [newGameMenu setPosition:CGPointZero];
  [self addChild:newGameMenu z:1];
}

@end