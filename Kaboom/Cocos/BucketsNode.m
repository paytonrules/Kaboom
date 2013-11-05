#import "BucketsNode.h"
#import "Buckets.h"
#import "Bucket.h"
#import "BucketSprite.h"

@interface BucketsNode ()

@property(strong) NSMutableArray *bucketSprites;

@end

@implementation BucketsNode

+(id)newNodeWithBuckets:(Buckets *)buckets
{
  BucketsNode *node = [BucketsNode new];

  node.bucketSprites = [NSMutableArray new];
  for (NSObject<Bucket> *bucket in buckets.buckets) {
    CCSprite *bucketSprite = [BucketSprite newSpriteWithBucket:bucket];
    [node.bucketSprites addObject:bucketSprite];
    [node addChild:bucketSprite];
  }

  [node scheduleUpdate];
  return node;
}

-(void)update:(ccTime)delta
{
  for (BucketSprite *bucket in self.bucketSprites)
  {
    [bucket update:delta];
  }
}


@end