#import "CreditsLayer.h"

@implementation CreditsLayer

+(CCScene *) scene
{
  CCScene *scene = [CCScene node];
  CreditsLayer *layer = [CreditsLayer node];
  [scene addChild: layer];

  return scene;
}

//
-(id) init
{
  if( (self = [super init])) {

    CGSize size = [[CCDirector sharedDirector] winSize];

    CCSprite *background;

    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
      background = [CCSprite spriteWithFile:@"Default.png"];
      background.rotation = 90;
    } else {
      background = [CCSprite spriteWithFile:@"Credits~ipad.png"];
    }
    background.position = ccp(size.width/2, size.height/2);
    [self addChild: background];
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
  [[CCDirector sharedDirector] popScene];
}

-(void) registerWithTouchDispatcher
{
  [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}


@end
