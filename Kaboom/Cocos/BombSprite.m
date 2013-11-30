#import "BombSprite.h"
#import "Bomb2D.h"
#import "BomberSprite.h"

@interface BombSprite()
@property(strong) NSObject<Bomb> *bomb;
@property(strong) BomberSprite* bomber;
@end

@implementation BombSprite

+(id) newSpriteWithBomb:(NSObject<Bomb> *) bomb
{
  BombSprite *sprite = [BombSprite spriteWithFile:@"bomb.png"];
  sprite.bomb = bomb;

  [sprite scheduleUpdate];
  return sprite;
}

-(void) update:(ccTime)delta
{
  self.position = self.bomb.position;
  ((Bomb2D *) self.bomb).boundingBox = self.boundingBox;
}

-(void) blowUp:(BomberSprite *) bomber
{
  CCParticleExplosion *explosion = [CCParticleExplosion node];
  [self addChild:explosion z:1];
  self.bomber = bomber;
  [self scheduleOnce:@selector(endExplosion) delay:1];
}

-(void) endExplosion
{
  BomberSprite *bomberSprite = self.bomber;
  self.bomber = nil;
  [bomberSprite bombBlownUp:self];
}

@end