#import "BombSprite.h"
#import "Bomb2D.h"
#import "BombExplosion.h"
#import "SimpleAudioEngine.h"

const int kBomb = 200;

@interface BombSprite()
@property(strong) NSObject<Bomb> *bomb;
@end

@implementation BombSprite

+(id) newSpriteWithBomb:(NSObject<Bomb> *) bomb
{
  BombSprite *sprite = [BombSprite spriteWithFile:@"Star.png"];
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"bomb.wav"];
  sprite.bomb = bomb;

  [sprite scheduleUpdate];
  return sprite;
}

-(void) update:(ccTime)delta
{
  self.position = self.bomb.position;
  ((Bomb2D *) self.bomb).boundingBox = self.boundingBox;
}

-(void) explode
{
  BombExplosion *explosion = [BombExplosion new];
  explosion.position = self.position;
  [[SimpleAudioEngine sharedEngine] playEffect:@"bomb.wav"];
  [self.parent addChild:explosion];
  [self removeFromParent];
}

@end