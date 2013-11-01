#import <Foundation/Foundation.h>

@class Bomber2D;
@class Buckets;

@interface KaboomLevel : NSObject

+(id) newLevelWithSize:(CGSize) size;
+(id) newLevelWithBomber:(Bomber2D *) bomber;
+(id) newLevelWithBuckets:(Buckets *) buckets;
+(id) newLevelWithBuckets:(Buckets *) buckets bomber:(Bomber2D *) bomber;
-(void) start;
-(void) update:(CGFloat) deltaTime;
-(void) tilt:(CGFloat) tilt;

@property(readonly) Bomber2D *bomber;
@property(readonly) Buckets *buckets;
@end