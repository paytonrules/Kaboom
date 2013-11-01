@protocol Buckets

@property(nonatomic, readonly) CGPoint position;
-(void) update:(CGFloat) deltaTime;
-(void) tilt:(float)angle;
-(BOOL) caughtBomb:(NSValue *)bomb;

@end