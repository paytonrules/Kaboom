#import "BomberSprite.h"
#import "Bomber.h"

const int kBomb = 200;

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

  [self.bomber.bombs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [self.parent removeChildByTag:kBomb + idx];
    NSValue *bombValue = (NSValue *)obj;
    CGPoint location;
    [bombValue getValue:&location];

    CCSprite *bombSprite = [CCSprite spriteWithFile:@"bomb.png"];
    bombSprite.position = location;
    [self.parent addChild:bombSprite z:0 tag:kBomb + idx];
  }];
}

@end