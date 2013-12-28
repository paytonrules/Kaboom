#import "LevelCollection.h"

@interface LevelCollection()
@property(strong) NSArray *levels;
@property(assign) int currentLevel;
@end

@implementation LevelCollection

+(id) newWithArray:(NSArray *)levels {
  LevelCollection *levelCollection = [LevelCollection new];
  levelCollection.levels = levels;
  return levelCollection;
}


- (NSDictionary *)next {
  NSDictionary *current = self.levels[self.currentLevel];
  if (self.currentLevel < self.levels.count - 1)
    self.currentLevel++;
  return current;
}
@end