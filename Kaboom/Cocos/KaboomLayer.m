#import "KaboomLayer.h"
#import "BucketsNode.h"
#import "BomberSprite.h"
#import "Kaboom.h"
#import "BombSprite.h"
#import "KaboomPresenter.h"

enum TAGS {
  kBucket,
  kBomber
};

@interface KaboomLayer ()
@property(strong) KaboomPresenter *presenter;
@property(strong) CCLabelTTF *score;
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
  if ((self = [super initWithColor:ccc4(57, 109, 58, 255)])) {
    CGSize size = [[CCDirector sharedDirector] winSize];
    self.touchEnabled = YES;
    self.accelerometerEnabled = YES;

    Kaboom *game = [Kaboom newLevelWithSize:[CCDirector sharedDirector].winSize];
    self.presenter = [KaboomPresenter newPresenterWithGame:game];

    BomberSprite *bomberSprite = [BomberSprite newSpriteWithBomber:game.bomber];
    BucketsNode *bucketSprite = [BucketsNode newNodeWithBuckets:game.buckets];
    [self addChild:bucketSprite z:0 tag:kBucket];
    [self addChild:bomberSprite z:0 tag:kBomber];
    CCLabelTTF *score = [CCLabelTTF labelWithString:@"TEST"
                                           fontName:@"Helvetica"
                                           fontSize:24];
    // DesignSize?
    score.position = ccp(size.width - 40, size.height - 40);

    [self addChild:score];
    self.score = score;

    [self scheduleUpdate];

    [self startLevel];
  }
  return self;
}

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
  [self.presenter tilt:-acceleration.y];
}

-(void) update:(ccTime)delta {
  // Mayhap you should go through the presenter for everything
  [self.presenter update:delta];
  [self.score setString:[NSString stringWithFormat:@"%d", self.presenter.score]];

  if (self.presenter.explode)
  {
    [self.presenter explosionStarted];
    [self blowUpBombs];
  }

  for (NSObject<Bomb> *bomb in self.presenter.removedBombs)
  {
    for (CCNode *node in self.children)
    {
      if (node.tag == kBomb && [node isEqual:bomb])
      {
        [node removeFromParentAndCleanup:YES];
      }
    }
  }

  for (NSObject<Bomb> *bomb in self.presenter.createdBombs)
  {
    BombSprite *bombSprite = [BombSprite newSpriteWithBomb:bomb];
    [self addChild:bombSprite z:0 tag:kBomb];
  }
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

-(void) startLevel
{
  [self.presenter start];
}

@end
