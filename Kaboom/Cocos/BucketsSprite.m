#import "BucketsSprite.h"
#import "Buckets2D.h"

@interface BucketsSprite()

@property(strong) NSObject<Buckets> *buckets;

@end

@implementation BucketsSprite

+(id)newSpriteWithBuckets:(NSObject<Buckets> *)buckets
{
  BucketsSprite *sprite = [BucketsSprite spriteWithFile:@"buckets.png"];
  sprite.buckets = buckets;

  [sprite scheduleUpdate];
  return sprite;
}

-(void)update:(ccTime)delta {
  ((Buckets2D *) self.buckets).boundingBox = self.boundingBox;
  [self setPosition:self.buckets.position];
}


@end