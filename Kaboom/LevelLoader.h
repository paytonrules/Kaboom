#import "LevelCollection.h"

@protocol LevelLoader

+(NSObject<LevelCollection> *) load;

@end