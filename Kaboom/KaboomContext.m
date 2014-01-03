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
  self.machine.levels = [self.levelLoader load];
  [self advanceToNextLevel];
}

-(void) gameOverNotification
{
  [[GameBlackboard sharedBlackboard] notify:kGameOver event:nil];
}

-(void) resetGame
{
  self.score = 0;
  [self.machine.buckets reset];
  [self startBombing];
}

-(void) advanceToNextLevel
{
  NSDictionary *level = [self.machine.levels next];
  [self startBomberAtLevel:level];
  [self.machine fire:@"New Level"];
}

-(void) restartLevel
{
  NSDictionary *level = [self.machine.levels current];
  [self startBomberAtLevel:level];
  [self.machine fire:@"Restarted"];
}

-(void) startBomberAtLevel:(NSDictionary *)level
{
  float speed = [level[@"Speed"] floatValue];
  int bombs = [level[@"Bombs"] intValue];
  [self.machine.bomber startAtSpeed:speed withBombs:bombs];
}

-(void) tilt:(CGFloat) tilt
{
  [self.machine.buckets tilt:tilt];
}

-(void) updatePlayers:(CGFloat) deltaTime
{
  [self.machine.bomber update:deltaTime];
  [self.machine.buckets update:deltaTime];
  self.score += [self.machine.bomber updateDroppedBombs:self.machine.buckets];

  if ([self.machine.bomber bombHit]) {
    [[GameBlackboard sharedBlackboard] notify:kBombHit event:nil];
    [self.machine.buckets removeBucket];
    [self.machine.bomber explode];

    if ([self.machine.buckets bucketCount] == 0) {
      [self.machine fire:@"End Game"];
    } else {
      [self.machine fire:@"Bomb Hit"];
    }
  } else if (self.machine.bomber.isOut) {
    [self.machine fire:@"Next Level"];
  } else {
    [self.machine fire:@"No Hit"];
  }
}

@end