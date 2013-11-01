#import "KaboomLevel.h"
#import "Bomber2D.h"
#import "Buckets.h"
#import "RandomLocationChooser.h"

@interface KaboomLevel()

@property(strong) Bomber2D *bomber;
@property(strong) Buckets *buckets;

@end

@implementation KaboomLevel : NSObject

+(id)newLevelWithSize:(CGSize)size
{
  KaboomLevel *level = [KaboomLevel new];
  level.buckets = [[Buckets alloc] initWithPosition:CGPointMake(size.width / 2, size.height / 2) speed:1.0];
  RandomLocationChooser *chooser = [RandomLocationChooser newChooserWithRange:NSMakeRange(0, size.width)];
  level.bomber = [[Bomber2D alloc] initWithPosition:CGPointMake(size.width / 2, size.height - 40)
                                                speed:60.0
                                      locationChooser:chooser];
  return level;
}

+(id) newLevelWithBomber:(Bomber2D *) bomber
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

+(id) newLevelWithBuckets:(Buckets *) buckets bomber:(Bomber2D *) bomber
{
  KaboomLevel *level = [KaboomLevel new];
  level.buckets = buckets;
  level.bomber = bomber;
  return level;
}

-(void) start
{
  [self.bomber start];
}

-(void) update:(CGFloat) deltaTime
{
  [self.bomber update:deltaTime];
  [self.buckets update:deltaTime];

  [self.bomber checkBombs:self.buckets];
}

-(void) tilt:(CGFloat) tilt
{
  [self.buckets tilt:tilt];
}
@end