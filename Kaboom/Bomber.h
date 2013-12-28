#import <Foundation/Foundation.h>

@class Buckets;

@protocol Bomber

@property(readonly) CGPoint position;
@property(readonly) int droppedBombCount;
@property(readonly) NSArray *bombs;
@property(readonly) BOOL exploding;
@property(readonly) BOOL isOut;
-(void) startAtSpeed:(float) speed withBombs:(int) count;
-(NSInteger)updateDroppedBombs:(Buckets *)buckets;
-(void) update:(float)deltaTime;
-(BOOL) bombHit;
-(void) explode;

@end