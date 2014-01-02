#import <Foundation/Foundation.h>
#import "KaboomStateMachine.h"

@interface KaboomContext : NSObject

+(id) newWithMachine:(NSObject<KaboomStateMachine> *) machine;
-(void) startBombing;
-(void) updatePlayers:(CGFloat) deltaTime;

@property(assign) int score;



@end