#import "BombingLayer.h"
#import "BucketsNode.h"
#import "BomberSprite.h"
#import "KaboomLevel.h"
#import "Utility.h"

enum TAGS {
  kBucket,
  kBomber
};

@interface BombingLayer()
@property(strong) KaboomLevel *level;
@property(strong) CCLabelTTF *score;
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

    self.level = [KaboomLevel newLevelWithSize:[Utility designSize]];

    BomberSprite *bomberSprite = [BomberSprite newSpriteWithBomber:self.level.bomber];
    BucketsNode *bucketSprite = [BucketsNode newNodeWithBuckets:self.level.buckets];
    [self addChild:bucketSprite z:0 tag:kBucket];
    [self addChild:bomberSprite z:0 tag:kBomber];
    CCLabelTTF  *score = [CCLabelTTF labelWithString:@"TEST"
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

-(void) update:(ccTime)delta
{
  [self.level update:delta];
  [self.score setString:[NSString stringWithFormat:@"%d", self.level.score]];
}

@end
