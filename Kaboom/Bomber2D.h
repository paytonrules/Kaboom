#import <Foundation/Foundation.h>
#import "LocationChooser.h"

@class Buckets;

@interface Bomber2D : NSObject
@property(readonly) CGPoint position;
@property(readonly) int bombCount;
@property(readonly) NSArray *bombs;

-(id) initWithPosition:(CGPoint)position speed:(float)speed locationChooser:(NSObject <LocationChooser> *)locations;
-(id) initWithPosition:(CGPoint)position speed:(float)speed locationChooser:(NSObject <LocationChooser> *)locations height:(int)height bombHeight:(int)bombHeight;

-(void) start;
-(void) checkBombs:(Buckets *)buckets;
-(void) update:(float)deltaTime;

-(void) dropBomb;
-(void) move:(float) amount;
@end