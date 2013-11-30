#import "BomberSprite.h"
#import "BombSprite.h"
#import "KaboomLayer.h"

const int kBomb = 200;

@interface BomberSprite()
@property(strong) NSObject<Bomber> *bomber;
@end

// Waaaay too much code here
// There's a state here - updating/not updating, managing that animation
// Abstraction?
// Actually the new implementation idea would fix that problem

// So here's what we really want to do:
 // Start level
    // On hit set BOMBER exploding not Level exploding
    // On restart level wait a few seconds
      // Then the level should start up again in the same spot

// NEW IMPLEMENTATION:
  // Requires solving the constant clear and rebinding of sprites
  // If you can do that then each bomb can be in the exploding state
    // When done you tell the next bomb to explode
      // During exploding bomber stops moving
        // When all bombs are exploded you restart the level
          // NOTE - in this scenario you only need to use Cocos for it's timer
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

  if (self.bomber.exploding) {
    [self startBlowingUpBombs];
    [self unscheduleAllSelectors];
  } else {
    [self redrawBombs];
  }
}

-(void) redrawBombs
{
  while ([self.parent getChildByTag:kBomb])
  {
    [self.parent removeChildByTag:kBomb cleanup:YES];
  }

  [self.bomber.bombs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    BombSprite *bombSprite = [BombSprite newSpriteWithBomb:obj];
    [self.parent addChild:bombSprite z:0 tag:kBomb];
  }];
}

-(void) startBlowingUpBombs
{
  [self blowUpNextBomb];
}

-(void) bombBlownUp:(BombSprite *) bombSprite
{
  [bombSprite removeFromParentAndCleanup:YES];
  [self blowUpNextBomb];
}

-(void) blowUpNextBomb
{
  BombSprite *bombSprite = (BombSprite *)[self.parent getChildByTag:kBomb];

  if (bombSprite) {
    [self blowUpBomb:bombSprite];
  } else {
    [self restartLevel];
  }
}

-(void) blowUpBomb:(BombSprite *) bombSprite
{
  [bombSprite blowUp:self];
}

-(void) restartLevel
{
  [(KaboomLayer *) self.parent restartLevel];
  [self scheduleUpdate];
}

@end