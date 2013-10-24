#import "RandomLocationChooser.h"
#import "StandardRandomNumberGenerator.h"

@interface RandomLocationChooser()

@property(assign) NSRange range;
@property(strong) NSObject<RandomNumberGenerator> *rand;

@end

@implementation RandomLocationChooser

+(id) newChooserWithRange:(NSRange)range {
  return [self newChooserWithRange:range generator:[StandardRandomNumberGenerator new]];
}

+(id) newChooserWithRange:(NSRange)range generator:(NSObject <RandomNumberGenerator> *)rand {
  RandomLocationChooser *chooser = [RandomLocationChooser new];
  chooser.range = range;
  chooser.rand = rand;
  return chooser;
}

-(float) next
{
  return [self.rand generate] * (float) self.range.length + (float) self.range.location;
}
@end