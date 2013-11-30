#import <Foundation/Foundation.h>

@class Buckets;

@protocol Bomber

@property(readonly) CGPoint position;
@property(readonly) int bombCount;
@property(readonly) NSArray *bombs;
-(void) startAtSpeed:(float) speed withBombs:(int) count;
-(NSInteger) checkBombs:(Buckets *)buckets;
-(void) update:(float)deltaTime;
-(BOOL) bombHit;
-(void) explode;
@property(readonly) BOOL exploding;

@end