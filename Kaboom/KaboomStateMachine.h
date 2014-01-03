@protocol LevelLoader;
@protocol Bomber;
@class Buckets;
@class LevelCollection;

@protocol KaboomStateMachine

// Keep an eye on these properties and methods - they may eventually be deleted
@property(strong) LevelCollection *levels;
@property(strong) NSObject<Bomber> *bomber;
@property(strong) Buckets *buckets;


//Legit
-(void) fire:(NSString *)eventName;

@end