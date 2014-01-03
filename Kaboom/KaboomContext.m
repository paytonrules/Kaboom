#import "KaboomContext.h"
#import "LevelCollection.h"
#import "LevelLoader.h"
#import "Buckets.h"
#import "Bomber.h"
#import "Event.h"
#import "GameBlackboard.h"

@interface KaboomContext()

-(void) startBomberAtLevel:(NSDictionary *)level;
@property(strong) NSObject<KaboomStateMachine> *machine;
@property(strong) LevelCollection *levels;
@end

@implementation KaboomContext

+(id) newWithMachine:(NSObject<KaboomStateMachine> *) machine
{
  KaboomContext *context = [KaboomContext new];
  context.machine = machine;
  return context;
}

-(void) startBombing
{
  self.levels = [self.levelLoader load];
  [self advanceToNextLevel];
}

-(void) gameOverNotification
{
  [[GameBlackboard sharedBlackboard] notify:kGameOver event:nil];
}

-(void) resetGame
{
  self.score = 0;
  [self.buckets reset];
  [self startBombing];
}

-(void) advanceToNextLevel
{
  NSDictionary *level = [self.levels next];
  [self startBomberAtLevel:level];
  [self.machine fire:@"New Level"];
}

-(void) restartLevel
{
  NSDictionary *level = [self.levels current];
  [self startBomberAtLevel:level];
  [self.machine fire:@"Restarted"];
}

-(void) startBomberAtLevel:(NSDictionary *)level
{
  float speed = [level[@"Speed"] floatValue];
  int bombs = [level[@"Bombs"] intValue];
  [self.bomber startAtSpeed:speed withBombs:bombs];
}

-(void) tilt:(CGFloat) tilt
{
  [self.buckets tilt:tilt];
}

-(void) updatePlayers:(CGFloat) deltaTime
{
  [self.bomber update:deltaTime];
  [self.buckets update:deltaTime];
  self.score += [self.bomber updateDroppedBombs:self.buckets];

  if ([self.bomber bombHit]) {
    [[GameBlackboard sharedBlackboard] notify:kBombHit event:nil];
    [self.buckets removeBucket];
    [self.bomber explode];

    if ([self.buckets bucketCount] == 0) {
      [self.machine fire:@"End Game"];
    } else {
      [self.machine fire:@"Bomb Hit"];
    }
  } else if (self.bomber.isOut) {
    [self.machine fire:@"Next Level"];
  } else {
    [self.machine fire:@"No Hit"];
  }
}

@end