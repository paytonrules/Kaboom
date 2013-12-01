#import <Foundation/Foundation.h>

@protocol Bomb

@property(assign) CGPoint position;
@property(readonly) BOOL exploding;

-(BOOL) hit;
-(void) explosionComplete;

@end