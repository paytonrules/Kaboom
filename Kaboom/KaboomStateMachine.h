@protocol LevelLoader;
@protocol Bomber;
@class Buckets;
@class LevelCollectionArray;

@protocol KaboomStateMachine
-(void) fire:(NSString *)eventName;

@end