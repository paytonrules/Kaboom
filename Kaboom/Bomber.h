#import <Foundation/Foundation.h>

@class Buckets;

@protocol Bomber

@property(readonly) CGPoint position;
@property(readonly) int bombCount;
@property(readonly) NSArray *bombs;
-(void) start;
-(NSInteger) checkBombs:(Buckets *)buckets;
-(void) update:(float)deltaTime;

@end