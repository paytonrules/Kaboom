@protocol LevelLoader;
@protocol Bomber;
@class Buckets;
@class LevelCollection;

@protocol KaboomStateMachine
-(void) fire:(NSString *)eventName;

@end