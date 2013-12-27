#import "KaboomLayer.h"
#import "BucketsNode.h"
#import "BomberSprite.h"
#import "Kaboom.h"
#import "BombSprite.h"
#import "GameBlackboard.h"
#import "Event.h"

enum TAGS {
  kBucket,
  kBomber
};

@interface KaboomLayer ()
@property(strong) Kaboom *game;
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

    self.game = [Kaboom newLevelWithSize:[CCDirector sharedDirector].winSize];

    BomberSprite *bomberSprite = [BomberSprite newSpriteWithBomber:self.game.bomber];
    BucketsNode *bucketSprite = [BucketsNode newNodeWithBuckets:self.game.buckets];
    [self addChild:bucketSprite z:0 tag:kBucket];
    [self addChild:bomberSprite z:0 tag:kBomber];
    CCLabelTTF *score = [CCLabelTTF labelWithString:@"TEST"
                                           fontName:@"Helvetica"
                                           fontSize:24];
    // DesignSize?
    score.position = ccp(size.width - 40, size.height - 40);

    GameBlackboard *blackboard = [GameBlackboard sharedBlackboard];
    [blackboard registerWatcher:self action:@selector(removeBomb:) event:kBombCaught];
    [blackboard registerWatcher:self action:@selector(bombHit:) event:kBombHit];
    [blackboard registerWatcher:self action:@selector(addBomb:) event:kBombDropped];

    [self addChild:score];
    self.score = score;

    [self scheduleUpdate];

    [self startLevel];
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

-(void) startLevel
{
  [self.game start];
}

@end
