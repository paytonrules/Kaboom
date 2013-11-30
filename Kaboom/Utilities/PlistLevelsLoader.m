#import "PlistLevelsLoader.h"

@implementation PlistLevelsLoader

+(NSArray *) load
{
  NSString *plistLevels = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"plist"];
  return [[NSArray alloc] initWithContentsOfFile:plistLevels];
}

@end

