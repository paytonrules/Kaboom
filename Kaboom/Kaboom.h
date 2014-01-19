#import <Foundation/Foundation.h>
#import "Bomber.h"
#import "KaboomStateMachine.h"
#import "LevelLoader.h"

@class Buckets;
@class KaboomContext;

@interface Kaboom : NSObject<KaboomStateMachine>

+(id) newLevelWithBomber:(NSObject<Bomber> *) bomber;
+(id) newLevelWithBuckets:(Buckets *) buckets bomber:(NSObject<Bomber> *) bomber;
+(id) newLevelWithBomber:(NSObject<Bomber> *) bomber buckets:(Buckets *) buckets andLevelLoader:(Class<LevelLoader>) loader;
-(void) start;
-(void) restart;

-(void) update:(CGFloat) deltaTime;
-(void) tilt:(CGFloat) tilt;

@property(assign) int score;
@property(strong) KaboomContext *gameContext;

// Possibly temp
@property(readonly) NSObject<Bomber>  *bomber;
@property(readonly) Buckets *buckets;
@end