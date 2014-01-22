#import <Foundation/Foundation.h>
#import "LevelCollection.h"

@interface LevelCollectionArray : NSObject<LevelCollection>

+(id) newWithArray:(NSArray *) levels;
@end