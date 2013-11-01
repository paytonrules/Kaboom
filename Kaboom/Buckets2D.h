#import <Foundation/Foundation.h>

@interface Buckets2D : NSObject

-(id) initWithPosition:(CGPoint) position speed:(CGFloat) speed;

@property(nonatomic, readonly) CGPoint position;
-(void) update:(CGFloat) deltaTime;
-(void) tilt:(float)angle;
-(BOOL) caughtBomb:(NSValue *)bomb;

@end