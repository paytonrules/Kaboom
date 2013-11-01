#import <Foundation/Foundation.h>
#import "Bomber.h"

@class Buckets2D;

@interface KaboomLevel : NSObject

+(id) newLevelWithSize:(CGSize) size;
+(id) newLevelWithBomber:(NSObject<Bomber> *) bomber;
+(id) newLevelWithBuckets:(Buckets2D *) buckets;
+(id) newLevelWithBuckets:(Buckets2D *) buckets bomber:(NSObject<Bomber> *) bomber;
-(void) start;
-(void) update:(CGFloat) deltaTime;
-(void) tilt:(CGFloat) tilt;

@property(readonly) NSObject<Bomber> *bomber;
@property(readonly) Buckets2D *buckets;
@end