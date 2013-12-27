#import "Kaboom.h"
#import "Bomber2D.h"
#import "Buckets.h"
#import "RandomLocationChooser.h"
#import "PlistLevelsLoader.h"
#import "GameBlackboard.h"
#import "Event.h"
#import <TransitionKit/TransitionKit.h>

@interface Kaboom ()

@property(strong) NSObject<Bomber> *bomber;
@property(strong) Buckets *buckets;
@property(assign) BOOL gameOver;
@property(strong) Class<LevelLoader> levelLoader;
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

+(id) newLevelWithBuckets:(Buckets *) buckets
{
  Kaboom *level = [Kaboom new];
  level.buckets = buckets;
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
    TKState *checkingBombs = [TKState stateWithName:@"Dropping"];
    TKState *exploding = [TKState stateWithName:@"Exploding"];
    TKState *gameOver = [TKState stateWithName:@"Game Over"];

    [droppingBombs setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
      [self startBombing];
    }];

    [checkingBombs setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
      [self checkBombs:[transition.userInfo[@"deltaTime"] floatValue]];
    }];

    [gameOver setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
      self.gameOver = YES;
    }];

    [self.gameStateMachine addStates:@[waitingForStart, droppingBombs, checkingBombs, exploding, gameOver]];
    self.gameStateMachine.initialState = waitingForStart;

    TKEvent *start = [TKEvent eventWithName:@"Start Game" transitioningFromStates:@[ waitingForStart, exploding ] toState:droppingBombs];
    TKEvent *bombHit = [TKEvent eventWithName:@"Bomb Hit" transitioningFromStates:@[ checkingBombs ] toState:exploding];
    TKEvent *endGame = [TKEvent eventWithName:@"End Game" transitioningFromStates:@[ checkingBombs ] toState:gameOver];
    TKEvent *update = [TKEvent eventWithName:@"Update" transitioningFromStates:@[ droppingBombs ] toState:checkingBombs];
    [self.gameStateMachine addEvents:@[ start, bombHit, endGame, update ]];

    [self.gameStateMachine activate];

    self.levelLoader = [PlistLevelsLoader class];
  }
  return self;
}

-(void) start
{
  [self.gameStateMachine fireEvent:@"Start Game" userInfo:nil error:nil];
}

-(void) startBombing
{
  NSArray *levels = [self.levelLoader load];
  float speed = [levels[0][@"Speed"] floatValue];
  int bombs = [levels[0][@"Bombs"] floatValue];

  [self.bomber startAtSpeed:speed withBombs:bombs];
}

-(void) update:(CGFloat) deltaTime
{
  NSDictionary *userInfo = @{@"deltaTime" : [NSNumber numberWithFloat:deltaTime]};
  [self.gameStateMachine fireEvent:@"Update" userInfo:userInfo error:nil];
}

-(void) checkBombs:(CGFloat) deltaTime
{
  [self.bomber update:deltaTime];
  [self.buckets update:deltaTime];

  if ([self.bomber bombHit]) {
    [[GameBlackboard sharedBlackboard] notify:kBombHit event:nil];
    [self.buckets removeBucket];
    [self.bomber explode];

    if ([self.buckets bucketCount] == 0) {
      [self.gameStateMachine fireEvent:@"End Game" userInfo:nil error:nil];
    } else {
      [self.gameStateMachine fireEvent:@"Bomb Hit" userInfo:nil error:nil];
    }
  }

  self.score += [self.bomber checkBombs:self.buckets];
}

// Does this belong here?  You don't tilt the game
-(void) tilt:(CGFloat) tilt
{
  [self.buckets tilt:tilt];
}

@end