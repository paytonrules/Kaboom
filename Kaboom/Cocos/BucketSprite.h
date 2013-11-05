#import <cocos2d/cocos2d.h>
#import "Bucket.h"

@interface BucketSprite : CCSprite

+(id) newSpriteWithBucket:(NSObject<Bucket> *) bucket;

@end