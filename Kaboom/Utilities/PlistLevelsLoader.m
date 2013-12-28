#import "PlistLevelsLoader.h"
#import "LevelCollection.h"

@implementation PlistLevelsLoader

+(LevelCollection *) load
{
  NSString *plistLevels = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"plist"];
  return [LevelCollection newWithArray:[[NSArray alloc] initWithContentsOfFile:plistLevels]];
}

@end

