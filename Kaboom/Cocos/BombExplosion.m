#import "BombExplosion.h"
#import "KaboomLayer.h"

@implementation BombExplosion

- (id)init {
  if (self = [super init]) {
    self.emitterMode = kCCParticleModeGravity;
    self.position = ccp(40.00, 20.00);
    self.emissionRate = 80.0;
    self.duration = 0.25;
    self.totalParticles = 250;
    self.life = 0.15;
    self.lifeVar = 0.25;
    self.startSize = 54.00;
    self.startSizeVar = 10.00;
    self.endSize = 0.0;
    self.endSizeVar = 0.0;
    self.startSpin = 0.0;
    self.startSpinVar = 0.0;
    self.endSpin = 0.0;
    self.endSpinVar = 0.0;
    self.angle = 90.0;
    self.angleVar = 10.0;
    self.startColor = ccc4f(194.0, 64.0, 31.0, 255.0);
    self.startColorVar = ccc4f(0.0, 0.0, 0.0, 0.0);
    self.endColor = ccc4f(0.0, 0.0, 0.0, 255.0);
    self.endColorVar = ccc4f(0.0, 0.0, 0.0, 0.0);
    [self setBlendFunc: (ccBlendFunc) { GL_ONE, GL_ONE }];
    self.texture = [[CCTextureCache sharedTextureCache] addImage: @"ccbParticleFire.png"];

    self.autoRemoveOnFinish = YES;
  }

  return self;
}

-(void) onExit
{
  [(KaboomLayer *)self.parent explosionComplete];
}
@end