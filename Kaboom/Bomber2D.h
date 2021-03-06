#import <Foundation/Foundation.h>
#import "LocationChooser.h"
#import "Bomber.h"

@interface Bomber2D : NSObject<Bomber>
-(id) initWithPosition:(CGPoint)position locationChooser:(NSObject <LocationChooser> *)locations;

-(void) dropBomb;
-(void) move:(float) amount;
@end