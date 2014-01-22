#import "LevelCollectionArray.h"

@interface LevelCollectionArray ()
@property(strong) NSArray *levels;
@property(assign) int currentLevel;
@end

@implementation LevelCollectionArray

+(id) newWithArray:(NSArray *)levels {
  LevelCollectionArray *levelCollection = [LevelCollectionArray new];
  levelCollection.levels = levels;
  return levelCollection;
}


-(void) next
{
  if (self.currentLevel < self.levels.count - 1)
    self.currentLevel++;
}

-(NSDictionary *) current
{
  return self.levels[self.currentLevel];
}

@end