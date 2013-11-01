#import <Foundation/Foundation.h>
#import "Buckets.h"

@protocol Bomber

@property(readonly) CGPoint position;
@property(readonly) int bombCount;
@property(readonly) NSArray *bombs;
-(void) start;
-(void) checkBombs:(NSObject<Buckets> *)buckets;
-(void) update:(float)deltaTime;

@end