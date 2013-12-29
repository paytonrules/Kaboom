#import <Foundation/Foundation.h>

@protocol Bomb

@property(assign) CGPoint position;
-(BOOL) hit;

@end