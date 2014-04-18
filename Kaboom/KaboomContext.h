#import <Foundation/Foundation.h>
#import "KaboomStateMachine.h"
#import "ScoreReporter.h"

@protocol LevelCollection;

@interface KaboomContext : NSObject

+(id) newWithMachine:(NSObject<KaboomStateMachine> *) machine;
-(void) startBombing;
-(void) updatePlayers:(CGFloat) deltaTime;
-(void) gameOverNotification;
-(void) resetGame;
-(void) advanceToNextLevel;
-(void) restartLevel;
-(void) tilt:(CGFloat) tilt;
-(void) reportScore;

@property(assign) int score;
@property(strong) NSObject<LevelCollection> *levels;
@property(strong) NSObject<Bomber> *bomber;
@property(strong) Buckets *buckets;
@property(strong) NSObject<ScoreReporter> *scoreReporter;

@end