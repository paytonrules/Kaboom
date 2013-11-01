@class Buckets2D;

@protocol Bomber

@property(readonly) CGPoint position;
@property(readonly) int bombCount;
@property(readonly) NSArray *bombs;
-(void) start;
-(void) checkBombs:(Buckets2D *)buckets;
-(void) update:(float)deltaTime;

@end