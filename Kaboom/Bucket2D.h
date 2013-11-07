#import <Foundation/Foundation.h>
#import "Bucket.h"

@interface Bucket2D : NSObject<Bucket>

+(id) newBucketWithPosition:(CGPoint) position;

@property(assign) CGRect boundingBox;

@end