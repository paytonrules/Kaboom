#import <Foundation/Foundation.h>

@interface Buckets : NSObject

@property(nonatomic, readonly) CGPoint position;

-(id) initWithPosition:(CGPoint) position;
- (void)move:(float)movement;
@end