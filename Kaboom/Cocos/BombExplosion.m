#import "BombExplosion.h"
#import "BombSprite.h"

@interface BombExplosion()

@property(strong) BombSprite *sprite;
@end

@implementation BombExplosion

+(id) newWithBombSprite:(BombSprite *)sprite
{
  BombExplosion *explosion = [BombExplosion new];
  explosion.sprite = sprite;
  return sprite;
}

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
  [self.sprite explosionComplete];
}
@end