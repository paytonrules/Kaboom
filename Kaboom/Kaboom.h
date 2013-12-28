#import <Foundation/Foundation.h>
#import "Bomber.h"

@class Buckets;
@protocol LevelLoader;
@class KaboomPresenter;

@interface Kaboom : NSObject

+(id) newLevelWithSize:(CGSize) size;
+(id) newLevelWithBomber:(NSObject<Bomber> *) bomber;
+(id) newLevelWithBuckets:(Buckets *) buckets bomber:(NSObject<Bomber> *) bomber;
+(id) newLevelWithBomber:(NSObject<Bomber> *) bomber andLevelLoader:(Class<LevelLoader>) loader;
-(void) start;
-(void) restart;

-(void) update:(CGFloat) deltaTime;
-(void) tilt:(CGFloat) tilt;

@property(readonly) NSObject<Bomber> *bomber;
@property(readonly) Buckets *buckets;
@property(assign) int score;
@property(readonly) BOOL gameOver;
@end