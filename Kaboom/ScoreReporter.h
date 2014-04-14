#import <Foundation/Foundation.h>

@protocol ScoreReporter <NSObject>

-(void) report:(int64_t) score;

@end
