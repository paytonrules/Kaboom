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

    // ask director for the window size
    CGSize size = [[CCDirector sharedDirector] winSize];

    CCSprite *background;

    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
      background = [CCSprite spriteWithFile:@"Default.png"];
      background.rotation = 90;
    } else {
      background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
    }
    background.position = ccp(size.width/2, size.height/2);

    // add the label as a child to this Layer
    [self addChild: background];
  }

  return self;
}


@end
