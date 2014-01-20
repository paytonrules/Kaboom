#import <Foundation/Foundation.h>

@protocol Bomb

@property(assign) CGPoint position;
@property(assign) int height;
-(BOOL) hit;

@end