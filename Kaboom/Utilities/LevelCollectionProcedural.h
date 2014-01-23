#import <Foundation/Foundation.h>
#import "LevelCollection.h"

@interface LevelCollectionProcedural : NSObject<LevelCollection>

+(id) newWithSpeed:(float)speed andBombs:(int)bombs;
@end