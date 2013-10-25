#import "BomberSprite.h"
#import "Bomber.h"

@interface BomberSprite()

@property(strong) Bomber *bomber;

@end

@implementation BomberSprite

+(id) newSpriteWithBomber:(Bomber *)bomber
{
  BomberSprite *sprite = [BomberSprite spriteWithFile:@"bomber.png"];
  sprite.bomber = bomber;
  [sprite scheduleUpdate];
  return sprite;
}

-(void)update:(ccTime)delta
{
  [self.bomber update:delta];
  [self setPosition:self.bomber.position];
}


@end