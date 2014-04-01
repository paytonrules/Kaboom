#import "MainMenuLayer.h"
#import "NavigationStateMachine.h"

@interface MainMenuLayer()
@property(strong) CCMenu *menu;
@property(strong) NavigationStateMachine *sm;

-(void) displayMainMenu;
@end

@implementation MainMenuLayer

// Boilerplate, boilerplate, bo bo ba boilerplate
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
    [self displayMainMenu];
  }
  return self;
}

-(void) displayMainMenu
{
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

  CCLabelBMFont *newGameLabel = [CCLabelBMFont labelWithString:@"New Game" fntFile:@"titlefnt.fnt"];
  CCMenuItemLabel *newGame = [CCMenuItemLabel itemWithLabel:newGameLabel target:self selector:@selector(newGame:)];
  [newGame setPosition:ccp(screenSize.width * 3 / 4, screenSize.height / 2 - (newGame.boundingBox.size.height))];

  CCLabelTTF *creditsLabel = [CCLabelBMFont labelWithString:@"Credits" fntFile:@"titlefnt.fnt"];
  CCMenuItemLabel *credits = [CCMenuItemLabel itemWithLabel:creditsLabel target:self selector:@selector(showCredits:)];
  float y = (screenSize.height / 2)  - (newGame.boundingBox.size.height * 1.5) - credits.boundingBox.size.height;
  [credits setPosition:ccp(screenSize.width * 3 / 4, y)];

  CCMenu *newGameMenu = [CCMenu menuWithItems:newGame, credits, nil];
  newGameMenu.visible = YES;
  [newGameMenu setPosition:CGPointZero];
  [self addChild:newGameMenu z:1];
  
  self.sm = [NavigationStateMachine newWithDelegate: self];
}

-(void) showCredits:(CCMenuItem *) label
{
  [self.sm showCredits];
}

-(void) newGame:(CCMenuItem *)label
{
  [self.sm startGame];
}

-(void) displayCredits
{
}

-(void) hideCredits
{
  
}

@end