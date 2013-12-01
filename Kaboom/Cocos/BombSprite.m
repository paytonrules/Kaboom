#import "BombSprite.h"
#import "Bomb2D.h"
#import "BomberSprite.h"
#import "BombExplosion.h"

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

  if (self.bomb.exploding) {
    [self explode];
    [self unscheduleUpdate];
  }
}

-(void) explode
{
  BombExplosion *explosion = [BombExplosion newWithBombSprite:self];
  [self addChild:explosion];
}

-(void) explosionComplete
{
  [self.bomb explosionComplete];
  [self removeFromParentAndCleanup:YES];
}

@end