#import <Foundation/Foundation.h>
#import "Bomb.h"

@interface Buckets : NSObject

+(int) initialBucketLocation;
@property(readonly) CGPoint position;
@property(readonly) NSArray *buckets;

-(void) update:(CGFloat) deltaTime;
-(void) tilt:(float)angle;
-(BOOL) caughtBomb:(NSObject<Bomb> *)bomb;
-(id) initWithPosition:(CGPoint) position speed:(CGFloat) speed;
-(void) removeBucket;
-(int) bucketCount;
-(void) reset;
-(void) setBucketHeight:(int) height;

@end