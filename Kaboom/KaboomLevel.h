#import <Foundation/Foundation.h>
#import "Bomber.h"

@class Buckets;

@interface KaboomLevel : NSObject

+(id) newLevelWithSize:(CGSize) size;
+(id) newLevelWithBomber:(NSObject<Bomber> *) bomber;
+(id) newLevelWithBuckets:(Buckets *) buckets;
+(id) newLevelWithBuckets:(Buckets *) buckets bomber:(NSObject<Bomber> *) bomber;
-(void) start;
-(void) update:(CGFloat) deltaTime;
-(void) tilt:(CGFloat) tilt;

@property(readonly) NSObject<Bomber> *bomber;
@property(readonly) Buckets *buckets;
@property(assign) int score;
@end