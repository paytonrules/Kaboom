#import "BomberSprite.h"
#import "Scaler.h"

@interface BomberSprite()

@property(strong) NSObject<Bomber> *bomber;
@end

@implementation BomberSprite

+(id) newSpriteWithBomber:(NSObject<Bomber> *)bomber
{
  BomberSprite *sprite = [BomberSprite spriteWithSpriteFrameName:@"bomber.png"];
  sprite.bomber = bomber;
  bomber.height = sprite.boundingBox.size.height;
  [sprite scheduleUpdate];
  return sprite;
}

-(void) update:(ccTime)delta
{
  [self setPosition:[self.scaler gameToView:self.bomber.position]];
}
@end