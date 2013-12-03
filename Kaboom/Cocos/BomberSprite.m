#import "BomberSprite.h"

@interface BomberSprite()
@property(strong) NSObject<Bomber> *bomber;
@end

@implementation BomberSprite

+(id) newSpriteWithBomber:(NSObject<Bomber> *)bomber
{
  BomberSprite *sprite = [BomberSprite spriteWithFile:@"bomber.png"];
  sprite.bomber = bomber;
  [sprite scheduleUpdate];
  return sprite;
}

-(void) update:(ccTime)delta
{
  [self setPosition:self.bomber.position];
}
@end