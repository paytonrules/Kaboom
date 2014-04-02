#import "CreditsLayer.h"
#import "NavigationStateMachine.h"

@interface CreditsLayer()

@property(strong) NavigationStateMachine *sm;

@end

@implementation CreditsLayer

+(CCScene *) scene
{
  return [self sceneWithMachine:nil];
}

+(CCScene *) sceneWithMachine:(NavigationStateMachine *)sm
{
  CCScene *scene = [CCScene node];
  CreditsLayer *layer = [CreditsLayer node];
  layer.sm = sm;
  [scene addChild: layer];
  
  return scene;
}

//
-(id) init
{
  if( (self = [super init])) {

    CGSize size = [[CCDirector sharedDirector] winSize];

    CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"background-empty.png"];
    [background setPosition:ccp(size.width / 2, size.height / 2)];
    [self addChild:background z:0];

    CCSprite *credits;
    credits = [CCSprite spriteWithSpriteFrameName:@"Credits.png"];
    credits.position = ccp(size.width / 2, size.height / 2);
    [self addChild:credits];
    [self setTouchEnabled:YES];
  }

  return self;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
  return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
  if (self.sm != nil) {
    [self.sm closeCredits];
  }
}

-(void) registerWithTouchDispatcher
{
  [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}


@end
