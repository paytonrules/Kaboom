#import <Foundation/Foundation.h>
#import "Bomber.h"

@class Kaboom;

@interface KaboomPresenter : NSObject

@property(readonly) NSArray *createdBombs;
@property(readonly) int score;
@property(readonly) BOOL exploding;

+(id) newPresenterWithGame:(Kaboom *) game;

-(void) tilt:(float)acceleration;
-(void) update:(CGFloat) delta;
-(void) explosionStarted;
-(void) start;

@end