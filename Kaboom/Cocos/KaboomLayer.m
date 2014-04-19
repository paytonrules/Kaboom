#import <iAd/iAd.h>
#import "KaboomLayer.h"
#import "BucketsNode.h"
#import "BomberSprite.h"
#import "Kaboom.h"
#import "BombSprite.h"
#import "GameBlackboard.h"
#import "Event.h"
#import "SimpleAudioEngine.h"
#import "Buckets.h"
#import "Scaler.h"
#import "CreditsLayer.h"
#import "AdDelegate.h"
#import "CocosDirectorAdapter.h"
#import "CCScene+SupportsAuthentication.h"
#import "CCDirector+PopTransition.h"

enum TAGS {
  kBucket,
  kBomber,
  kEndScreen
};

@interface KaboomLayer ()
@property(strong) Kaboom *game;
@property(strong) CCLabelTTF *score;
@property(strong) ADBannerView *banner;
@end

@implementation KaboomLayer

// Helper class method that creates a Scene with the KaboomLayer as the only child.
+ (CCScene *)scene {
  // 'scene' is an autorelease object.
  CCScene *scene = [CCScene node];

  // 'layer' is an autorelease object.
  KaboomLayer *layer = [KaboomLayer node];

  // add layer as a child to scene
  [scene addChild:layer];

  // return the scene
  return scene;
}

- (id)init {
  if ((self = [super initWithColor:ccc4(0, 0, 0, 0)])) {
    CGSize size = [[CCDirector sharedDirector] winSize];
    self.touchEnabled = YES;
    self.accelerometerEnabled = YES;

    self.game = [Kaboom new];

    CCSpriteBatchNode *gameArt;
    gameArt = [CCSpriteBatchNode batchNodeWithFile:@"game-sprites0.pvr.ccz"];
    [self addChild:gameArt];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"game-sprites0.plist"];

    CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"background.png"];
    [background setPosition:ccp(size.width / 2, size.height / 2)];
    [self addChild:background z:0];

    BomberSprite *bomberSprite = [BomberSprite newSpriteWithBomber:self.game.bomber];
    [self addChild:bomberSprite z:0 tag:kBomber];

    BucketsNode *bucketsNode = [BucketsNode newNodeWithBuckets:self.game.buckets];
    CGPoint bucketSizeAsPoints = CGPointMake(0, bucketsNode.bucketHeight);
    CGPoint scaledBucketSize = [[Scaler new] viewToGame:bucketSizeAsPoints];
    [self.game.buckets setBucketHeight:scaledBucketSize.y];
    [self addChild:bucketsNode z:0 tag:kBucket];

    CCLabelTTF *score = [CCLabelTTF labelWithString:@"0"
                                           fontName:@"Helvetica"
                                           fontSize:24];
    // DesignSize?
    score.position = ccp(size.width - 40, size.height - 80);

    GameBlackboard *blackboard = [GameBlackboard sharedBlackboard];
    [blackboard registerWatcher:self action:@selector(removeBomb:) event:kBombCaught];
    [blackboard registerWatcher:self action:@selector(bombHit:) event:kBombHit];
    [blackboard registerWatcher:self action:@selector(addBomb:) event:kBombDropped];
    [blackboard registerWatcher:self action:@selector(gameOver:) event:kGameOver];

    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"DST-Garote.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"catch.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"bomb.wav"];

    [self addChild:score];
    self.score = score;

    CCDirectorIOS *director = (CCDirectorIOS*) [CCDirector sharedDirector];

    self.banner = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    CGSize flippedSize = CGSizeMake(size.height, size.width);
    CGSize bannerBounds = [self.banner sizeThatFits:flippedSize];
    [self.banner setFrame:CGRectMake(0, 0, bannerBounds.width, bannerBounds.height)];


    AdDelegate *adDelegate = [AdDelegate newWithDirector:
                              [CocosDirectorAdapter newWithCocosDirector:director]];
    self.banner.delegate = adDelegate;
    [director.view addSubview:self.banner];

    [self scheduleUpdate];

    [self startGame];
  }
  return self;
}

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
  [self.game tilt:-acceleration.y];
}

-(void) update:(ccTime)delta {
  [self.game update:delta];
  [self.score setString:[NSString stringWithFormat:@"%d", self.game.score]];
}

-(void) removeBomb:(Event *) evt
{
  [[SimpleAudioEngine sharedEngine] playEffect:@"catch.wav"];
  for (BombSprite *bombSprite in self.children)
  {
    if (bombSprite.tag == kBomb && [bombSprite.bomb isEqual:evt.data])
    {
      [bombSprite removeFromParentAndCleanup:YES];
    }
  }
}

-(void) addBomb:(Event *) evt
{
  BombSprite *bombSprite = [BombSprite newSpriteWithBomb:evt.data];
  [self addChild:bombSprite z:0 tag:kBomb];
}

-(void) bombHit:(Event *) evt
{
  [self blowUpBombs];
}

-(void) blowUpBombs
{
  BombSprite *sprite = (BombSprite *) [self getChildByTag:kBomb];

  if (sprite != nil)
  {
    [sprite explode];
  }
  else
  {
    [self restartLevel];
  }
}

-(void) explosionComplete
{
  [self blowUpBombs];
}

-(void) restartLevel
{
  [self scheduleOnce:@selector(startLevel) delay:1];
}

-(void) startGame
{
  [self.game start];
  [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"DST-Garote.caf"];
}

-(void) gameOver:(Event *) evt
{
  CGSize size = [CCDirector sharedDirector].winSize;

  NSString *scoreText = [NSString stringWithFormat:@"You caught %d stars before the world ended. Try again?", self.game.score];
  CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:scoreText fntFile:@"gamefnt.fnt"];
  [scoreLabel setPosition:ccp(size.width / 2, (size.height - (size.height / 3)))];
  [self addChild:scoreLabel z:1 tag:kEndScreen];

  CCLabelBMFont *newGameLabel = [CCLabelBMFont labelWithString:@"Replay" fntFile:@"gamefnt.fnt"];
  CCMenuItemLabel *item = [CCMenuItemLabel itemWithLabel:newGameLabel target:self selector:@selector(newGame:)];
  [item setPosition:ccp(size.width / 2, size.height / 2)];

  CCLabelBMFont *quitLabel = [CCLabelBMFont labelWithString:@"Give Up" fntFile:@"gamefnt.fnt"];
  CCMenuItemLabel *quitItem = [CCMenuItemLabel itemWithLabel:quitLabel target:self selector:@selector(stopShowingGame:)];
  [quitItem setPosition:ccp(size.width / 2, size.height / 2 - (item.boundingBox.size.height))];

  CCMenu *newGameMenu = [CCMenu menuWithItems:item, quitItem, nil];
  newGameMenu.visible = YES;
  [newGameMenu setPosition:CGPointZero];
  [self addChild:newGameMenu z:1];
}

-(void) newGame:(CCMenuItem *) label
{
  [label.parent removeFromParent];
  [self removeChildByTag:kEndScreen ];
  [self.game start];
}

-(void) stopShowingGame:(CCMenuItem *) label
{
  [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:1.0];
  [self.banner removeFromSuperview];
  [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

-(void) startLevel
{
  [self.game restart];
}

@end
