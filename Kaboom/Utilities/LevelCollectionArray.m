#import "LevelCollectionArray.h"
#import "Level.h"

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

-(Level *) current
{
  NSDictionary *currentLevel = self.levels[self.currentLevel];
  return [Level newLevelWithBombs:[currentLevel[@"Bombs"] intValue]
                            speed:[currentLevel[@"Speed"] floatValue]];
}

@end