#import <cocos2d/cocos2d.h>

@class Buckets;

@interface BucketsNode : CCNode

+(id)newNodeWithBuckets:(Buckets *)buckets;
-(int) bucketHeight;

@end