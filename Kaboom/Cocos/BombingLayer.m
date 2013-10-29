#import "BombingLayer.h"
#import "BucketsSprite.h"
#import "BomberSprite.h"
#import "KaboomLevel.h"

enum TAGS {
  kBucket,
  kBomber
};

@interface BombingLayer()
@property(strong) KaboomLevel *level;
@end

@implementation BombingLayer

// Helper class method that creates a Scene with the BombingLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	BombingLayer *layer = [BombingLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
  if( (self = [super initWithColor:ccc4(57, 109, 58, 255)]) ) {
		CGSize size = [[CCDirector sharedDirector] winSize];
    self.touchEnabled = YES;
    self.accelerometerEnabled = YES;

    self.level = [KaboomLevel newLevelWithSize:size];

    BomberSprite *bomberSprite = [BomberSprite newSpriteWithBomber:self.level.bomber];
    BucketsSprite *bucketSprite = [BucketsSprite newSpriteWithBuckets:self.level.buckets];
    [self addChild:bucketSprite z:0 tag:kBucket];
    [self addChild:bomberSprite z:0 tag:kBomber];
    [self scheduleUpdate];

    [self.level start];
  }
	return self;
}

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
  [self.level tilt:acceleration.y];
}

-(void) update:(ccTime)delta
{
  [self.level update:delta];
}

@end
