#import <Foundation/Foundation.h>
#import "LocationChooser.h"

@interface Bomber : NSObject
@property(readonly) CGPoint position;

- (id)initWithPosition:(CGPoint)position speed:(float)speed locationChooser:(NSObject <LocationChooser> *)locations;
- (void)start;
- (void)update:(float)deltaTime;
@end