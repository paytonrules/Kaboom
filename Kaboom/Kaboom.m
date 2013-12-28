#import "Kaboom.h"
#import "Bomber2D.h"
#import "Buckets.h"
#import "RandomLocationChooser.h"
#import "PlistLevelsLoader.h"
#import "GameBlackboard.h"
#import "Event.h"
#import "LevelCollection.h"
#import <TransitionKit/TransitionKit.h>

@interface Kaboom ()

@property(strong) NSObject<Bomber> *bomber;
@property(strong) Buckets *buckets;
@property(assign) BOOL gameOver;
@property(strong) Class<LevelLoader> levelLoader;
@property(strong) LevelCollection *levels;
@property(strong) TKStateMachine *gameStateMachine;
@end

@implementation Kaboom : NSObject

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
  level.levelLoader = loader;
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

    TKState *waitingForStart = [TKState stateWithName:@"Waiting"];
    TKState *droppingBombs = [TKState stateWithName:@"Dropping"];
    TKState *updatingSystem = [TKState stateWithName:@"Updating"];
    TKState *restartingLevel = [TKState stateWithName:@"Restarting"];
    TKState *exploding = [TKState stateWithName:@"Exploding"];
    TKState *gameOver = [TKState stateWithName:@"Game Over"];
    TKState *finishingLevel = [TKState stateWithName:@"Finishing Level"];

    [waitingForStart setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
      [self startBombing];
    }];

    [updatingSystem setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
      [self updatePlayers:[transition.userInfo[@"deltaTime"] floatValue]];
      [self checkBombs];
    }];

    [gameOver setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
      self.gameOver = YES;
    }];

    [finishingLevel setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
      [self advanceToNextLevel];
    }];

    [restartingLevel setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
      [self restartLevel];
    }];

    [self.gameStateMachine addStates:@[waitingForStart, droppingBombs, updatingSystem, exploding, gameOver,
        finishingLevel, restartingLevel]];
    self.gameStateMachine.initialState = waitingForStart;

    TKEvent *start = [TKEvent eventWithName:@"Start Game" transitioningFromStates:@[ waitingForStart ] toState:droppingBombs];
    TKEvent *restart = [TKEvent eventWithName:@"Restart Level" transitioningFromStates:@[ exploding ] toState:restartingLevel];
    TKEvent *restarted = [TKEvent eventWithName:@"Restarted" transitioningFromStates:@[ restartingLevel ] toState:droppingBombs];
    TKEvent *bombHit = [TKEvent eventWithName:@"Bomb Hit" transitioningFromStates:@[updatingSystem] toState:exploding];
    TKEvent *endGame = [TKEvent eventWithName:@"End Game" transitioningFromStates:@[updatingSystem] toState:gameOver];
    TKEvent *nextLevel = [TKEvent eventWithName:@"Next Level" transitioningFromStates:@[updatingSystem] toState:finishingLevel];
    TKEvent *noHits = [TKEvent eventWithName:@"No Hit" transitioningFromStates:@[updatingSystem] toState:droppingBombs];
    TKEvent *update = [TKEvent eventWithName:@"Update" transitioningFromStates:@[droppingBombs] toState:updatingSystem];
    [self.gameStateMachine addEvents:@[ start, bombHit, endGame, noHits, update, nextLevel, restart, restarted ]];

    [self.gameStateMachine activate];

    self.levelLoader = [PlistLevelsLoader class];
  }
  return self;
}

-(void) start
{
  [self.gameStateMachine fireEvent:@"Start Game" userInfo:nil error:nil];
}

-(void) restart
{
  [self.gameStateMachine fireEvent:@"Restart Level" userInfo:nil error:nil];
}

-(void) startBombing
{
  self.levels = [self.levelLoader load];
  [self advanceToNextLevel];
}

-(void) advanceToNextLevel
{
  NSDictionary *level = [self.levels next];
  [self startBomberAtLevel:level];
}

-(void) restartLevel
{
  NSDictionary *level = [self.levels current];
  [self startBomberAtLevel:level];
  [self.gameStateMachine fireEvent:@"Restarted" userInfo:nil error:nil];
}

-(void) startBomberAtLevel:(NSDictionary *)level {
  float speed = [level[@"Speed"] floatValue];
  int bombs = [level[@"Bombs"] intValue];
  [self.bomber startAtSpeed:speed withBombs:bombs];
}

-(void) update:(CGFloat) deltaTime
{
  NSDictionary *userInfo = @{@"deltaTime" : [NSNumber numberWithFloat:deltaTime]};
  [self.gameStateMachine fireEvent:@"Update" userInfo:userInfo error:nil];
}

-(void) updatePlayers:(CGFloat) deltaTime
{
  [self.bomber update:deltaTime];
  [self.buckets update:deltaTime];
  self.score += [self.bomber updateDroppedBombs:self.buckets];
}

-(void) checkBombs
{
  if ([self.bomber bombHit]) {
    [[GameBlackboard sharedBlackboard] notify:kBombHit event:nil];
    [self.buckets removeBucket];
    [self.bomber explode];

    if ([self.buckets bucketCount] == 0) {
      [self.gameStateMachine fireEvent:@"End Game" userInfo:nil error:nil];
    } else {
      [self.gameStateMachine fireEvent:@"Bomb Hit" userInfo:nil error:nil];
    }
  } else if (self.bomber.droppedBombCount == 0) {
    [self.gameStateMachine fireEvent:@"Next Level" userInfo:nil error: nil];
  } else {
    [self.gameStateMachine fireEvent:@"No Hit" userInfo:nil error: nil];
  }
}

// Does this belong here?  You don't tilt the game
-(void) tilt:(CGFloat) tilt
{
  [self.buckets tilt:tilt];
}

@end