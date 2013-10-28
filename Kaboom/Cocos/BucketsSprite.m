#import "BucketsSprite.h"
#import "Buckets.h"

@interface BucketsSprite()

@property(strong) Buckets *buckets;

@end

@implementation BucketsSprite

+(id)newSpriteWithBuckets:(Buckets *)buckets
{
  BucketsSprite *sprite = [BucketsSprite spriteWithFile:@"buckets.png"];
  sprite.buckets = buckets;

  [sprite scheduleUpdate];
  return sprite;
}

-(void)update:(ccTime)delta {
  [self setPosition:self.buckets.position];
}


@end