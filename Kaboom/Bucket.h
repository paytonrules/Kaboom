#import "Bomb.h"

@protocol Bucket

@property(readonly) BOOL removed;
@property(assign) CGPoint position;

-(BOOL) caughtBomb:(NSObject<Bomb> *)bomb;
-(void) remove;
-(void) putBack;

@end