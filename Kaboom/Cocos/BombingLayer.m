#import "BombingLayer.h"
#import "BucketsSprite.h"
#import "RandomLocationChooser.h"
#import "BomberSprite.h"
#import "InputTranslator.h"
#import "KaboomLevel.h"

enum TAGS {
  kBucket,
  kBomber
};

@interface BombingLayer()
@property(strong) InputTranslator *translator;
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
    
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];

    self.translator = [InputTranslator newTranslatorWithWidth:size.width];

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

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
  [self.translator newTouch:touch at:[touch locationInView:[touch view]]];
  return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
  [self.translator moveTouch:touch to:[touch locationInView:[touch view]]];
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
  [self.translator removeTouch:touch];
}

-(void)update:(ccTime)delta
{
  [self.level moveBuckets:self.translator.movement];
  [self.level update:delta];
}

@end
