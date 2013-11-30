#import "KaboomLayer.h"
#import "BucketsNode.h"
#import "BomberSprite.h"
#import "Kaboom.h"

enum TAGS {
  kBucket,
  kBomber
};

@interface KaboomLayer ()
@property(strong) Kaboom *level;
@property(strong) CCLabelTTF *score;
@property(strong) CCSequence *explosionAnimation;
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

    self.level = [Kaboom newLevelWithSize:[CCDirector sharedDirector].winSize];

    BomberSprite *bomberSprite = [BomberSprite newSpriteWithBomber:self.level.bomber];
    BucketsNode *bucketSprite = [BucketsNode newNodeWithBuckets:self.level.buckets];
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
  [self.level tilt:-acceleration.y];
}

-(void) update:(ccTime)delta {
  [self.level update:delta];
  [self.score setString:[NSString stringWithFormat:@"%d", self.level.score]];
}

-(void) restartLevel
{
  [self scheduleOnce:@selector(startLevel) delay:1];
}

-(void) startLevel
{
  [self.level start];
}

@end
