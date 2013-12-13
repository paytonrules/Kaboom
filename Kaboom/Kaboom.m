#import "Kaboom.h"
#import "Bomber2D.h"
#import "Buckets.h"
#import "RandomLocationChooser.h"
#import "PlistLevelsLoader.h"
#import "KaboomPresenter.h"

@interface Kaboom ()

@property(strong) NSObject<Bomber> *bomber;
@property(strong) Buckets *buckets;
@property(assign) BOOL gameOver;
@property(strong) Class<LevelLoader> levelLoader;

@end

@implementation Kaboom : NSObject

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

-(id) init {

  if (self = [super init])
  {
    self.gameOver = NO;
    self.levelLoader = [PlistLevelsLoader class];
  }
  return self;
}

-(void) start
{
  NSArray *levels = [self.levelLoader load];
  float speed = [levels[0][@"Speed"] floatValue];
  int bombs = [levels[0][@"Bombs"] floatValue];

  [self.bomber startAtSpeed:speed withBombs:bombs];
}

-(void) update:(CGFloat) deltaTime
{
  if (!self.gameOver) {
    [self.bomber update:deltaTime];
    [self.buckets update:deltaTime];

    if ([self.bomber bombHit]) {
      [self.buckets removeBucket];
      [self.bomber explode];

      if ([self.buckets bucketCount] == 0) {
        self.gameOver = YES;
      }
    }

    self.score += [self.bomber checkBombs:self.buckets];
  }
}

// Does this belong here?  You don't tilt the game
-(void) tilt:(CGFloat) tilt
{
  [self.buckets tilt:tilt];
}

@end