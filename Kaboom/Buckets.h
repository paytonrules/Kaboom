#import <Foundation/Foundation.h>

@interface Buckets : NSObject

@property(nonatomic, readonly) CGPoint position;

-(id) initWithPosition:(CGPoint) position speed:(CGFloat) speed;

-(void) update:(CGFloat) deltaTime;
-(void) tilt:(float)angle;
@end