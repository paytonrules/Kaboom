#import "BombExplosion.h"
#import "BombSprite.h"
#import "KaboomLayer.h"


@implementation BombExplosion

- (id)init {
  self = [super init];
  if (self) {
    self.autoRemoveOnFinish = YES;
  }

  return self;
}

-(void) onExit
{
  [(KaboomLayer *)self.parent explosionComplete];
}
@end