#include "Level.h"

@implementation Level

+(id) newLevelWithBombs:(int) bombs speed:(float) speed
{
  Level *level = [Level new];
  level.bombs = bombs;
  level.speed = speed;
  return level;
}

@end