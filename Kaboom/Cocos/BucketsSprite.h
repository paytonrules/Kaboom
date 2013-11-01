#import <cocos2d/cocos2d.h>
#import "Buckets.h"

@class Buckets2D;

@interface BucketsSprite : CCSprite

+(id)newSpriteWithBuckets:(NSObject<Buckets> *)buckets;

@end