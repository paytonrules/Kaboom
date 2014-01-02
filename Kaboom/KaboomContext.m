#import "KaboomContext.h"
#import "LevelLoader.h"
#import "Buckets.h"
#import "Bomber.h"
#import "Event.h"
#import "GameBlackboard.h"

@interface KaboomContext()

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
  self.machine.levels = [self.machine.levelLoader load];
  [self.machine advanceToNextLevel];
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