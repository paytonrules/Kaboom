#import <Foundation/Foundation.h>

@class Bomber;
@class Buckets;

@interface KaboomLevel : NSObject

+(id) newLevelWithSize:(CGSize) size;
+(id) newLevelWithBomber:(Bomber *) bomber;
+(id) newLevelWithBuckets:(Buckets *) buckets;
-(void) start;
-(void) update:(CGFloat) deltaTime;
-(void) tilt:(CGFloat) tilt;

@property(readonly) Bomber *bomber;
@property(readonly) Buckets *buckets;
@end