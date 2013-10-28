#import <Foundation/Foundation.h>

@class Bomber;
@class Buckets;

@interface KaboomLevel : NSObject

+(id) newLevelWithSize:(CGSize) size;
+(id) newLevelWithBomber:(Bomber *) bomber;
-(void) start;

@property(readonly) Bomber *bomber;
@property(readonly) Buckets *buckets;
@end