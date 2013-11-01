#import "BomberSprite.h"
#import "BombSprite.h"

const int kBomb = 200;

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

  while ([self.parent getChildByTag:kBomb])
  {
    [self.parent removeChildByTag:kBomb cleanup:YES];
  }

  [self.bomber.bombs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    BombSprite *bombSprite = [BombSprite newSpriteWithBomb:obj];
    [self.parent addChild:bombSprite z:0 tag:kBomb];
  }];
}

@end