#import "Bomb.h"

@protocol Bucket

@property(readonly) BOOL removed;
@property(readonly) CGPoint position;

-(BOOL) caughtBomb:(NSObject<Bomb> *)bomb;
-(void) remove;

@end