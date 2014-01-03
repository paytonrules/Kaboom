#import "Kaboom.h"
#import "Bomber2D.h"
#import "Buckets.h"
#import "RandomLocationChooser.h"
#import "PlistLevelsLoader.h"
#import "LevelCollection.h"
#import "KaboomContext.h"
#import <TransitionKit/TransitionKit.h>

@interface Kaboom ()

@property(strong) TKStateMachine *gameStateMachine;
@end

@implementation Kaboom : NSObject

@synthesize levels, bomber, buckets;

// Seems inappropriate - not sure the Kaboom game should know about size
// it's the state of the system.
+(id) newLevelWithSize:(CGSize)size
{
  Kaboom *level = [Kaboom new];
  level.buckets = [[Buckets alloc] initWithPosition:CGPointMake(size.width / 2, 180.0f)
                                              speed:1.0];
  RandomLocationChooser *chooser = [RandomLocationChooser newChooserWithRange:NSMakeRange(0, size.width)];

  level.bomber = [[Bomber2D alloc] initWithPosition:CGPointMake(size.width / 2, size.height - 60.0)
                                    locationChooser:chooser];
  return level;
}

+(id) newLevelWithBomber:(NSObject<Bomber> *) bomber
{
  Kaboom *level = [Kaboom new];
  level.bomber = bomber;
  return level;
}

+(id) newLevelWithBomber:(NSObject<Bomber> *) bomber andLevelLoader:(Class<LevelLoader>) loader
{
  Kaboom *level = [self newLevelWithBomber:bomber];
  level.gameContext.levelLoader = loader;
  return level;
}

+(id) newLevelWithBuckets:(Buckets *) buckets bomber:(NSObject<Bomber> *) bomber
{
  Kaboom *level = [Kaboom new];
  level.buckets = buckets;
  level.bomber = bomber;
  return level;
}

-(id) init
{
  if (self = [super init])
  {
    self.gameStateMachine = [TKStateMachine new];
    self.gameContext = [KaboomContext newWithMachine:self];
    self.gameContext.levelLoader = [PlistLevelsLoader class];

    TKState *waitingForStart = [TKState stateWithName:@"Waiting"];
    TKState *droppingBombs = [TKState stateWithName:@"Dropping"];
    TKState *updatingSystem = [TKState stateWithName:@"Updating"];
    TKState *restartingLevel = [TKState stateWithName:@"Restarting"];
    TKState *exploding = [TKState stateWithName:@"Exploding"];
    TKState *gameOver = [TKState stateWithName:@"Game Over"];
    TKState *finishingLevel = [TKState stateWithName:@"Finishing Level"];

    [waitingForStart setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
      [self.gameContext startBombing];;
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

    TKEvent *start = [TKEvent eventWithName:@"Start Game" transitioningFromStates:@[ waitingForStart, gameOver ] toState:droppingBombs];
    TKEvent *restart = [TKEvent eventWithName:@"Restart Level" transitioningFromStates:@[ exploding ] toState:restartingLevel];
    TKEvent *restarted = [TKEvent eventWithName:@"Restarted" transitioningFromStates:@[ restartingLevel ] toState:droppingBombs];
    TKEvent *newLevel = [TKEvent eventWithName:@"New Level" transitioningFromStates:@[finishingLevel] toState:droppingBombs];
    TKEvent *bombHit = [TKEvent eventWithName:@"Bomb Hit" transitioningFromStates:@[updatingSystem] toState:exploding];
    TKEvent *endGame = [TKEvent eventWithName:@"End Game" transitioningFromStates:@[updatingSystem] toState:gameOver];
    TKEvent *nextLevel = [TKEvent eventWithName:@"Next Level" transitioningFromStates:@[updatingSystem] toState:finishingLevel];
    TKEvent *noHits = [TKEvent eventWithName:@"No Hit" transitioningFromStates:@[updatingSystem] toState:droppingBombs];
    TKEvent *update = [TKEvent eventWithName:@"Update" transitioningFromStates:@[droppingBombs] toState:updatingSystem];
    [self.gameStateMachine addEvents:@[ start, bombHit, endGame, noHits, update, nextLevel, restart, restarted, newLevel ]];

    [self.gameStateMachine activate];
  }
  return self;
}

-(void) setScore:(int)score
{
  self.gameContext.score = score;
}

-(int) score
{
  return self.gameContext.score;
}

-(void)fire:(NSString *)eventName
{
  [self.gameStateMachine fireEvent:eventName userInfo:nil error:nil];
}

-(void) start
{
  [self.gameStateMachine fireEvent:@"Start Game" userInfo:nil error:nil];
}

-(void) restart
{
  [self.gameStateMachine fireEvent:@"Restart Level" userInfo:nil error:nil];
}

-(void) update:(CGFloat) deltaTime
{
  NSDictionary *userInfo = @{@"deltaTime" : [NSNumber numberWithFloat:deltaTime]};
  [self.gameStateMachine fireEvent:@"Update" userInfo:userInfo error:nil];
}

// Does this belong here?  You don't tilt the game
-(void) tilt:(CGFloat) tilt
{
  [self.gameContext tilt:tilt];
}

@end