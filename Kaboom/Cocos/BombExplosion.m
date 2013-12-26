#import "BombExplosion.h"
#import "BombSprite.h"
#import "KaboomLayer.h"


@implementation BombExplosion

- (id)init {
  self = [super init];
  if (self) {
    self.duration = 1.0f;
    self.autoRemoveOnFinish = YES;
  }

  return self;
}

-(void) onExit
{
  NSLog(@"Here I am %@", self);
  [(KaboomLayer *)self.parent explosionComplete];
}
@end