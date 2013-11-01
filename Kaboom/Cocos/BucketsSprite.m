#import "BucketsSprite.h"
#import "Buckets2D.h"

@interface BucketsSprite()

@property(strong) Buckets2D *buckets;

@end

@implementation BucketsSprite

+(id)newSpriteWithBuckets:(Buckets2D *)buckets
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