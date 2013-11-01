#import <Foundation/Foundation.h>
#import "Bomber.h"
#import "Buckets.h"

@interface KaboomLevel : NSObject

+(id) newLevelWithSize:(CGSize) size;
+(id) newLevelWithBomber:(NSObject<Bomber> *) bomber;
+(id) newLevelWithBuckets:(NSObject<Buckets> *) buckets;
+(id) newLevelWithBuckets:(NSObject<Buckets> *) buckets bomber:(NSObject<Bomber> *) bomber;
-(void) start;
-(void) update:(CGFloat) deltaTime;
-(void) tilt:(CGFloat) tilt;

@property(readonly) NSObject<Bomber> *bomber;
@property(readonly) NSObject<Buckets> *buckets;
@end