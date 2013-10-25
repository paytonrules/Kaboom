#import <cocos2d/cocos2d.h>

@class Buckets;

@interface BucketsSprite : CCSprite

+(id)newSpriteWithBuckets:(Buckets *)buckets;
-(void) move:(float) movement;

@end