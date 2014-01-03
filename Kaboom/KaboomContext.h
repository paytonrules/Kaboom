#import <Foundation/Foundation.h>
#import "KaboomStateMachine.h"

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
@property(strong) Class<LevelLoader> levelLoader;

@end