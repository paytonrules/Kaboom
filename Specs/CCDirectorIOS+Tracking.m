#import <cocos2d/cocos2d.h>
#import "CCDirectorIOS+Tracking.h"
#import <objc/runtime.h>

static char kPlayingKey;

@implementation CCDirectorIOS (Tracking)

-(void) setPlaying:(BOOL)playing
{
  objc_setAssociatedObject(self,
                           &kPlayingKey,
                           [NSNumber numberWithBool:playing],
                           OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL) playing
{
  NSNumber *num = objc_getAssociatedObject(self, &kPlayingKey);
  return [num boolValue];
}

-(void) resume
{
  self.playing = true;

}

-(void) pause
{
  self.playing = false;
}

@end
