#import "Kaboom.h"
#import "Bomber2D.h"
#import "Buckets.h"
#import "RandomLocationChooser.h"
#import "LevelCollection.h"
#import "KaboomContext.h"
#import "Constants.h"
#import "LevelCollectionProcedural.h"
#import <TransitionKit/TransitionKit.h>

@interface Kaboom ()

@property(strong) TKStateMachine *gameStateMachine;
@end

@implementation Kaboom : NSObject

+ (id)newLevelWithBomber:(NSObject <Bomber> *)bomber {
  Kaboom *level = [Kaboom new];
  level.gameContext.bomber = bomber;
  return level;
}

+ (id)newLevelWithBuckets:(Buckets *)buckets bomber:(NSObject <Bomber> *)bomber {
  Kaboom *level = [Kaboom new];
  level.gameContext.buckets = buckets;
  level.gameContext.bomber = bomber;
  return level;
}

+(id) newLevelWithContext:(KaboomContext *) context
{
  Kaboom *level = [Kaboom new];
  level.gameContext = context;
  return level;
}

- (id)init {
  if (self = [super init]) {
    self.gameStateMachine = [TKStateMachine new];
    self.gameContext = [KaboomContext newWithMachine:self];
    self.gameContext.levels = [LevelCollectionProcedural newWithSpeed:INITIAL_SPEED andBombs:INITIAL_BOMBS];

    // Seems not quite right from a dependency standpoint
    RandomLocationChooser *chooser = [RandomLocationChooser newChooserWithRange:NSMakeRange(0, GAME_WIDTH)];
    self.gameContext.bomber = [[Bomber2D alloc] initWithPosition:CGPointMake(GAME_WIDTH / 2, 0)
                                                locationChooser:chooser];
    self.gameContext.buckets = [[Buckets alloc] initWithPosition:CGPointMake(GAME_WIDTH / 2, 180.0f)
                                                            speed:1.0];

    TKState *waitingForStart = [TKState stateWithName:@"Waiting"];
    TKState *droppingBombs = [TKState stateWithName:@"Dropping"];
    TKState *updatingSystem = [TKState stateWithName:@"Updating"];
    TKState *restartingLevel = [TKState stateWithName:@"Restarting"];
    TKState *exploding = [TKState stateWithName:@"Exploding"];
    TKState *gameOver = [TKState stateWithName:@"Game Over"];
    TKState *finishingLevel = [TKState stateWithName:@"Finishing Level"];

    [waitingForStart setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
      [self.gameContext startBombing];
    }];

    [updatingSystem setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
      [self.gameContext updatePlayers:[transition.userInfo[@"deltaTime"] floatValue]];
    }];

    [gameOver setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
      [self.gameContext gameOverNotification];
    }];

    [gameOver setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
      [self.gameContext resetGame];
    }];

    [finishingLevel setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
      [self.gameContext advanceToNextLevel];
    }];

    [restartingLevel setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
      [self.gameContext restartLevel];
    }];

    [self.gameStateMachine addStates:@[waitingForStart, droppingBombs, updatingSystem, exploding, gameOver,
        finishingLevel, restartingLevel]];
    self.gameStateMachine.initialState = waitingForStart;

    TKEvent *start = [TKEvent eventWithName:@"Start Game" transitioningFromStates:@[waitingForStart, gameOver] toState:droppingBombs];
    TKEvent *restart = [TKEvent eventWithName:@"Restart Level" transitioningFromStates:@[exploding] toState:restartingLevel];
    TKEvent *restarted = [TKEvent eventWithName:@"Restarted" transitioningFromStates:@[restartingLevel] toState:droppingBombs];
    TKEvent *newLevel = [TKEvent eventWithName:@"New Level" transitioningFromStates:@[finishingLevel] toState:droppingBombs];
    TKEvent *bombHit = [TKEvent eventWithName:@"Bomb Hit" transitioningFromStates:@[updatingSystem] toState:exploding];
    TKEvent *endGame = [TKEvent eventWithName:@"End Game" transitioningFromStates:@[updatingSystem] toState:gameOver];
    TKEvent *nextLevel = [TKEvent eventWithName:@"Next Level" transitioningFromStates:@[updatingSystem] toState:finishingLevel];
    TKEvent *noHits = [TKEvent eventWithName:@"No Hit" transitioningFromStates:@[updatingSystem] toState:droppingBombs];
    TKEvent *update = [TKEvent eventWithName:@"Update" transitioningFromStates:@[droppingBombs] toState:updatingSystem];
    [self.gameStateMachine addEvents:@[start, bombHit, endGame, noHits, update, nextLevel, restart, restarted, newLevel]];

    [self.gameStateMachine activate];
  }
  return self;
}

-(void) setScore:(int)score {
  self.gameContext.score = score;
}

-(int) score {
  return self.gameContext.score;
}

-(NSObject <Bomber> *) bomber {
  return self.gameContext.bomber;
}

-(Buckets*) buckets
{
  return self.gameContext.buckets;
}

-(void) fire:(NSString *)eventName
{
  [self.gameStateMachine fireEvent:eventName userInfo:nil error:nil];
}

- (void) start {
  [self.gameStateMachine fireEvent:@"Start Game" userInfo:nil error:nil];
}

- (void) restart {
  [self.gameStateMachine fireEvent:@"Restart Level" userInfo:nil error:nil];
}

- (void) update:(CGFloat)deltaTime {
  NSDictionary *userInfo = @{@"deltaTime" : [NSNumber numberWithFloat:deltaTime]};
  [self.gameStateMachine fireEvent:@"Update" userInfo:userInfo error:nil];
}

// Does this belong here?  You don't tilt the game
- (void) tilt:(CGFloat)tilt {
  [self.gameContext tilt:tilt];
}

@end