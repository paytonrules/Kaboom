#import <Foundation/Foundation.h>
#import "Bomber.h"

@class Kaboom;

@interface KaboomPresenter : NSObject

@property(readonly) BOOL explode;
@property(readonly) NSArray *removedBombs;
@property(readonly) NSArray *createdBombs;
@property(readonly) int score;

+(id) newPresenterWithGame:(Kaboom *) game;
+(id) newPresenterWithBomber:(NSObject<Bomber> *) bomber;

-(void) tilt:(UIAccelerationValue)acceleration;
-(void) update:(CGFloat) delta;
-(void) explosionStarted;
-(void) start;

@end