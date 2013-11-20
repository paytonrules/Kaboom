#import "KaboomLevel.h"
#import "Bomber2D.h"
#import "Buckets.h"
#import "RandomLocationChooser.h"

@interface KaboomLevel()

@property(strong) NSObject<Bomber> *bomber;
@property(strong) Buckets *buckets;
@property(assign) BOOL gameOver;

@end

@implementation KaboomLevel : NSObject

+(id) newLevelWithSize:(CGSize)size
{
  KaboomLevel *level = [KaboomLevel new];
  level.buckets = [[Buckets alloc] initWithPosition:CGPointMake(size.width / 2, 180.0f)
                                              speed:1.0];
  RandomLocationChooser *chooser = [RandomLocationChooser newChooserWithRange:NSMakeRange(0, size.width)];

  level.bomber = [[Bomber2D alloc] initWithPosition:CGPointMake(size.width / 2, size.height - 60.0)
                                              speed:60.0
                                    locationChooser:chooser];
  return level;
}

+(id) newLevelWithBomber:(NSObject<Bomber> *) bomber
{
  KaboomLevel *level = [KaboomLevel new];
  level.bomber = bomber;
  return level;
}

+(id) newLevelWithBuckets:(Buckets *) buckets
{
  KaboomLevel *level = [KaboomLevel new];
  level.buckets = buckets;
  return level;
}

+(id) newLevelWithBuckets:(Buckets *) buckets bomber:(NSObject<Bomber> *) bomber
{
  KaboomLevel *level = [KaboomLevel new];
  level.buckets = buckets;
  level.bomber = bomber;
  return level;
}

-(id) init {

  if (self = [super init])
  {
    self.gameOver = NO;
  }
  return self;
}

-(void) start
{
  [self.bomber start];
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

-(void) tilt:(CGFloat) tilt
{
  [self.buckets tilt:tilt];
}
@end