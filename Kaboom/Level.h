#import <Foundation/Foundation.h>

@interface Level : NSObject

@property(assign) int bombs;
@property(assign) float speed;

+(id) newLevelWithBombs:(int) bombs speed:(float) speed;
@end

