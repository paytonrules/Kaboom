#import "PlistLevelsLoader.h"
#import "LevelCollectionArray.h"

@implementation PlistLevelsLoader

+(LevelCollectionArray *) load
{
  NSString *plistLevels = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"plist"];
  return [LevelCollectionArray newWithArray:[[NSArray alloc] initWithContentsOfFile:plistLevels]];
}

@end

