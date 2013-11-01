#import <Foundation/Foundation.h>
#import "Buckets.h"

@interface Buckets2D : NSObject<Buckets>

-(id) initWithPosition:(CGPoint) position speed:(CGFloat) speed;

@property(assign) CGRect boundingBox;

@end