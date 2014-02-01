#import <Foundation/Foundation.h>
#import "KaboomStateMachine.h"

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

@property(assign) int score;
@property(strong) NSObject<LevelCollection> *levels;
@property(strong) NSObject<Bomber> *bomber;
@property(strong) Buckets *buckets;

@end