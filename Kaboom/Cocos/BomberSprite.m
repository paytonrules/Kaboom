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
  CGPoint boundingBoxAsPoint = CGPointMake(sprite.boundingBox.size.width, sprite.boundingBox.size.height);
  CGPoint scaledBoundingBox = [[Scaler new] viewToGame:boundingBoxAsPoint];
  bomber.height = scaledBoundingBox.y;
  [sprite scheduleUpdate];
  return sprite;
}

-(void) update:(ccTime)delta
{
  [self setPosition:[self.scaler gameToView:self.bomber.position]];
}
@end