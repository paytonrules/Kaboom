#import "CCDirector+PopTransition.h"
#import <cocos2d/CCTransition.h>

@implementation CCDirector (PopTransition)

-(void) popSceneWithTransition:(Class)transitionClass duration:(ccTime) t
{
  NSAssert(self.runningScene != nil, @"A running Scene is needed");
  
  [_scenesStack removeLastObject];
  NSUInteger c = [_scenesStack count];
  
  if( c == 0 ) {
    [self end];
  } else {
    CCScene* scene = [transitionClass transitionWithDuration:t scene:[_scenesStack objectAtIndex:c-1]];
    [_scenesStack replaceObjectAtIndex:c-1 withObject:scene];
    _nextScene = scene;
  }
}

@end
