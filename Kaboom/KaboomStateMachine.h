@protocol LevelLoader;
@protocol Bomber;
@class Buckets;
@class LevelCollection;

@protocol KaboomStateMachine

// Keep an eye on these properties and methods - they may eventually be deleted
@property(strong) Class<LevelLoader> levelLoader;
@property(strong) LevelCollection *levels;
@property(strong) NSObject<Bomber> *bomber;
@property(strong) Buckets *buckets;

-(void) advanceToNextLevel;

//Legit
-(void) fire:(NSString *)eventName;

@end