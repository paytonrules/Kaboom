#import "BombingLayer.h"
#import "Buckets.h"
#import "BucketsSprite.h"
#import "Bomber.h"
#import "RandomLocationChooser.h"
#import "BomberSprite.h"
#import "InputTranslator.h"

enum TAGS {
  kBucket,
  kBomber
};

@interface BombingLayer()
@property(strong) InputTranslator *translator;
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

    Buckets *buckets = [[Buckets alloc] initWithPosition:CGPointMake(size.width / 2, size.height / 2)];
    RandomLocationChooser *chooser = [RandomLocationChooser newChooserWithRange:NSMakeRange(0, size.width)];
    BucketsSprite *bucketSprite = [BucketsSprite newSpriteWithBuckets:buckets];
    Bomber *bomber = [[Bomber alloc] initWithPosition:CGPointMake(size.width / 2, size.height - 40)
                                                speed:60.0
                                      locationChooser:chooser];
    BomberSprite *bomberSprite = [BomberSprite newSpriteWithBomber:bomber];


    [self addChild:bucketSprite z:0 tag:kBucket];
    [self addChild:bomberSprite z:0 tag:kBomber];
    self.touchEnabled = YES;
    
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [self scheduleUpdate];

    self.translator = [InputTranslator newTranslatorWithWidth:size.width];
    [bomber start];
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
  BucketsSprite *sprite = (BucketsSprite *)[self getChildByTag:kBucket];
  [sprite move:self.translator.movement];
}

@end
