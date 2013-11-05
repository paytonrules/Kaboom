#import "BucketSprite.h"
#import "Bucket.h"
#import "Bucket2D.h"

@interface BucketSprite()

@property(strong) NSObject<Bucket> *bucket;

@end

@implementation BucketSprite

+(id) newSpriteWithBucket:(NSObject<Bucket> *)bucket
{
  BucketSprite *sprite = [BucketSprite spriteWithFile:@"buckets.png"];
  sprite.bucket = bucket;
  return sprite;
}

-(void)update:(ccTime)delta
{
  [self setPosition:self.bucket.position];
  ((Bucket2D *) self.bucket).boundingBox = self.boundingBox;
}

@end
