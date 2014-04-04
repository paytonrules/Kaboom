#import "MainMenuLayer.h"
#import "NavigationStateMachine.h"
#import "CreditsLayer.h"
#import "KaboomLayer.h"
#import "CCDirector+PopTransition.h"
#import "AppDelegate.h"

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

  CCLabelTTF *highScoresLabel = [CCLabelBMFont labelWithString:@"High Scores" fntFile:@"titlefnt.fnt"];
  CCMenuItemLabel *highScores = [CCMenuItemLabel itemWithLabel:highScoresLabel target:self selector:@selector(showHighScores:)];
  float y = (screenSize.height / 2)  - (newGame.boundingBox.size.height * 1.1) - highScores.boundingBox.size.height;
  [highScores setPosition:ccp(screenSize.width * 3 / 4, y)];

  CCLabelTTF *creditsLabel = [CCLabelBMFont labelWithString:@"Credits" fntFile:@"titlefnt.fnt"];
  CCMenuItemLabel *credits = [CCMenuItemLabel itemWithLabel:creditsLabel target:self selector:@selector(showCredits:)];
  y = (screenSize.height / 2)  - (2 * (newGame.boundingBox.size.height * 1.1)) - credits.boundingBox.size.height;
  [credits setPosition:ccp(screenSize.width * 3 / 4, y)];

  CCMenu *newGameMenu = [CCMenu menuWithItems:newGame, highScores, credits, nil];
  newGameMenu.visible = YES;
  [newGameMenu setPosition:CGPointZero];
  [self addChild:newGameMenu z:1];
  
  self.sm = [NavigationStateMachine newWithDelegate: self];
}

-(void) displayGame
{
  [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1. scene:[KaboomLayer scene]]];
}

-(void) showCredits:(CCMenuItem *) label
{
  [self.sm showCredits];
}

-(void) newGame:(CCMenuItem *)label
{
  [self.sm startGame];
}

-(void) showHighScores:(CCMenuItem *) label
{
  GKGameCenterViewController *gc = [GKGameCenterViewController new];
  gc.viewState = GKGameCenterViewControllerStateLeaderboards;
  gc.delegate = self;
  [[CCDirector sharedDirector] presentViewController:gc animated:YES completion:^{}];

  
}

-(void) displayCredits
{
  [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.0 scene:[CreditsLayer sceneWithMachine:self.sm] ]];
}

-(void) hideCredits
{
  [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:1.0];
}



@end