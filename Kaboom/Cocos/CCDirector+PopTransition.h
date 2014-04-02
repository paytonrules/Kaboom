#import "CCDirector.h"

@interface CCDirector (PopTransition)
-(void) popSceneWithTransition:(Class)transitionClass duration:(ccTime) t;

@end
