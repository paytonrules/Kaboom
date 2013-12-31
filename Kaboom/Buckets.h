#import <Foundation/Foundation.h>
#import "Bomb.h"

@interface Buckets : NSObject

@property(nonatomic, readonly) CGPoint position;
-(void) update:(CGFloat) deltaTime;
-(void) tilt:(float)angle;
-(BOOL) caughtBomb:(NSObject<Bomb> *)bomb;
-(id) initWithPosition:(CGPoint) position speed:(CGFloat) speed;
-(void) removeBucket;
-(int) bucketCount;
-(void) reset;

@property(readonly) NSArray *buckets;

@end