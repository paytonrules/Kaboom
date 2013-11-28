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

    [self.level start];
  }
  return self;
}

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
  [self.level tilt:-acceleration.y];
}

-(void) update:(ccTime)delta {
  [self.level update:delta];
  [self.score setString:[NSString stringWithFormat:@"%d", self.level.score]];

  if (self.level.exploding && [self numberOfRunningActions] == 0) {
    [self runAction: [CCSequence actions:
        [CCDelayTime actionWithDuration:3],
        [CCCallFunc actionWithTarget:self selector:@selector(restartLevel)],
        nil ]];
  }
}

// Bomb hits
  // Game says "Bomber explode"
    // Bomber stops moving
    // Bombs - explode (so Bomber tells bombs to explode)
      // Bombs say "exploding"
      // Bomb Sprites play explode animation
        // When the bombs are done exploding, you re-start
        // "Update" would say "if [bomber.bombs] == 0 -> restart
          // ?

  // How do we start again?  What I'm doing here doesn't make sense

@end
