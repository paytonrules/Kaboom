#import "BombSprite.h"
#import "Bomb2D.h"

@interface BombSprite()
@property(strong) NSObject<Bomb> *bomb;
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

@end