#import "KaboomLevel.h"
#import "Bomber.h"
#import "Buckets.h"
#import "RandomLocationChooser.h"

@interface KaboomLevel()

@property(strong) Bomber *bomber;
@property(strong) Buckets *buckets;

@end

@implementation KaboomLevel : NSObject

+(id)newLevelWithSize:(CGSize)size
{
  KaboomLevel *level = [KaboomLevel new];
  level.buckets = [[Buckets alloc] initWithPosition:CGPointMake(size.width / 2, size.height / 2)];
  RandomLocationChooser *chooser = [RandomLocationChooser newChooserWithRange:NSMakeRange(0, size.width)];
  level.bomber = [[Bomber alloc] initWithPosition:CGPointMake(size.width / 2, size.height - 40)
                                                speed:60.0
                                      locationChooser:chooser];
  return level;
}

+(id) newLevelWithBomber:(Bomber *) bomber
{
  KaboomLevel *level = [KaboomLevel new];
  level.bomber = bomber;
  return level;
}

-(void) start
{
  [self.bomber start];
}
@end