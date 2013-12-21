#import "GameBlackboard.h"
#import "Event.h"

@interface Watcher : NSObject
@property(assign) SEL action;
@property(strong) id target;
@end

@implementation Watcher
@end

@interface GameBlackboard()

@property(strong) NSMutableDictionary *watchList;
@end

@implementation GameBlackboard

+(id) sharedBlackboard {
  static GameBlackboard *blackboard = nil;

  // Note - not thread safe
  if (blackboard == nil) {
    blackboard = [GameBlackboard new];
  }
  return blackboard;
}

-(id) init
{
  if (self = [super init])
  {
    self.watchList = [NSMutableDictionary new];
  }

  return self;
}

-(void) notify:(NSInteger)eventNumber event:(Event *)evt
{
  NSArray *watchers = self.watchList[[NSNumber numberWithInt:eventNumber]];

  [watchers enumerateObjectsUsingBlock:^(Watcher *watcher, NSUInteger idx, BOOL *stop) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [watcher.target performSelector:watcher.action withObject:evt];
#pragma clang diagnostic pop
  }];
}

-(void)registerWatcher:(id)target action:(SEL)selector event:(NSInteger)eventId
{
  Watcher *watcher = [Watcher new];
  watcher.action = selector;
  watcher.target = target;
  NSNumber *eventIdNum = [NSNumber numberWithInt:eventId];
  if (self.watchList[eventIdNum])
    self.watchList[eventIdNum] = [self.watchList[eventIdNum] arrayByAddingObject:watcher];
  else
    self.watchList[eventIdNum] = @[watcher];
}

-(void) clear
{
  self.watchList = [NSMutableDictionary new];
}

@end
