#import <Foundation/Foundation.h>
#import "LocationChooser.h"

@interface Bomber : NSObject
@property(readonly) CGPoint position;
@property(readonly) int bombCount;
@property(readonly) NSArray *bombs;

- (id)initWithPosition:(CGPoint)position speed:(float)speed locationChooser:(NSObject <LocationChooser> *)locations;
- (void)start;

- (id)initWithPosition:(CGPoint)position speed:(float)speed locationChooser:(NSObject <LocationChooser> *)locations height:(int)height bombHeight:(int)bombHeight;

- (void)update:(float)deltaTime;
@end