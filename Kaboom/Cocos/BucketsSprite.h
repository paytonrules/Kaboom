#import <cocos2d/cocos2d.h>

@class Buckets;

@interface BucketsSprite : CCSprite

+(id) spriteWithBuckets:(Buckets *)buckets;
-(void) move:(float) movement;

@end