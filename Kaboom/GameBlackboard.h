@class Event;

@interface GameBlackboard : NSObject
+(id) sharedBlackboard;
-(void) registerWatcher:(id) target action:(SEL) selector event:(NSInteger) eventId;
-(void) notify:(NSInteger) eventNumber event:(Event *) evt;
-(void) clear;
@end
