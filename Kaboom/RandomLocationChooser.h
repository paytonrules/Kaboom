#import <Foundation/Foundation.h>
#import "LocationChooser.h"
#import "RandomNumberGenerator.h"

@interface RandomLocationChooser : NSObject<LocationChooser>

+(id) newChooserWithRange:(NSRange)range;
+(id) newChooserWithRange:(NSRange)range generator:(NSObject <RandomNumberGenerator> *)rand;

@property(readonly) NSObject<RandomNumberGenerator> *rand;
@end