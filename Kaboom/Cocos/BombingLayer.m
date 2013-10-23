#import "BombingLayer.h"
#import "Buckets.h"
#import "BucketsSprite.h"

enum TAGS {
  kBucket
};

@interface BombingLayer()

@property(assign) float movement;

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
  if( (self = [super init]) ) {
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];

    Buckets *buckets = [[Buckets alloc] initWithPosition:CGPointMake(size.width / 2, size.height / 2)];
    BucketsSprite *sprite = [BucketsSprite spriteWithBuckets:buckets];

		// add the sprite as a child to this Layer
    [self addChild:sprite z:0 tag:kBucket];
    self.touchEnabled = YES;
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [self scheduleUpdate];
  }
	return self;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
  CGPoint point = [touch locationInView:[touch view]];
  CGSize size = [[CCDirector sharedDirector] winSize];

  if (point.x > size.width / 2)
  {
    self.movement++;
  }
  else
  {
    self.movement--;
  }
  return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
  CGPoint point = [touch locationInView:[touch view]];
  CGSize size = [[CCDirector sharedDirector] winSize];

  if (point.x > size.width / 2)
  {
    self.movement--;
  }
  else
  {
    self.movement++;
  }
}

-(void)update:(ccTime)delta
{
  BucketsSprite *sprite = (BucketsSprite *)[self getChildByTag:kBucket];
  [sprite move:self.movement];
}

@end
