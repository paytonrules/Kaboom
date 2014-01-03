#import "CocosSizeStrategy.h"
#import <cocos2d/cocos2d.h>

@implementation CocosSizeStrategy

-(CGSize) screenSize
{
  return [[CCDirector sharedDirector] winSize];
}
@end
