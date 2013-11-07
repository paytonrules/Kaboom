#import "Bomb.h"

@protocol Bucket

@property(readonly) CGPoint position;
-(BOOL) caughtBomb:(NSObject<Bomb> *)bomb;

@end