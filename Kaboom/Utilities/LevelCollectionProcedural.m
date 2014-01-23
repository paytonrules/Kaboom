#import "LevelCollectionProcedural.h"
#import "Level.h"

@interface LevelCollectionProcedural()

@property(assign) float initialSpeed;
@property(assign) int initialBombs;
@property(assign) int level;
@end

@implementation LevelCollectionProcedural

+(id) newWithSpeed:(float)speed andBombs:(int)bombs
{
  LevelCollectionProcedural *level = [LevelCollectionProcedural new];
  level.initialSpeed = speed;
  level.initialBombs = bombs;
  return level;
}

- (void)next
{
  self.level++;
}

- (Level *)current
{
  float speed = (self.level + 1) * self.initialSpeed;
  int bombs = (self.initialBombs / 2 * self.level) + self.initialBombs;
  return [Level newLevelWithBombs:bombs speed:speed];
}


@end