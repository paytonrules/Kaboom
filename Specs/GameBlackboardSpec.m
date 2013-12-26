#import <OCDSpec2/OCDSpec2.h>
#import "GameBlackboard.h"
#import "Event.h"

@interface TestWatcher : NSObject
@property(strong) Event *evtAction;
@property(strong) Event *evtActionTwo;
@end

@implementation TestWatcher
-(void) action:(Event *) evt
{
  self.evtAction = evt;
}

-(void) actionTwo:(Event *)evt
{
  self.evtActionTwo = evt;
}
@end

OCDSpec2Context(GameBlackboardSpec) {

  Describe(@"A blackboard", ^{

    BeforeEach(^{
      [[GameBlackboard sharedBlackboard] clear];
    });

    It(@"has a singleton", ^{
      GameBlackboard *blackboard = [GameBlackboard sharedBlackboard];
      GameBlackboard *blackboardTwo = [GameBlackboard sharedBlackboard];

      [ExpectObj(blackboard) toBe:blackboardTwo];
      [ExpectObj(blackboard) toExist];
    });

    It(@"will write to a registered watcher", ^{
      TestWatcher *watcher = [TestWatcher new];
      GameBlackboard *blackboard = [GameBlackboard sharedBlackboard];

      [blackboard registerWatcher:watcher action:@selector(action:) event:200];
      Event *event = [Event newEventWithData:@""];

      [blackboard notify:200 event:event];

      [ExpectObj(watcher.evtAction) toBe:event];
    });

    It(@"will not write if the event doesn't match", ^{
      TestWatcher *watcher = [TestWatcher new];
      GameBlackboard *blackboard = [GameBlackboard sharedBlackboard];

      [blackboard registerWatcher:watcher action:@selector(action:) event:100];
      Event *event = [Event newEventWithData:@""];

      [blackboard notify:200 event:event];

      [ExpectObj(watcher.evtAction) toBeNil];
    });

    It(@"will write multiple events to the same object, if registered", ^{
      TestWatcher *watcher = [TestWatcher new];
      GameBlackboard *blackboard = [GameBlackboard sharedBlackboard];

      [blackboard registerWatcher:watcher action:@selector(action:) event:100];
      [blackboard registerWatcher:watcher action:@selector(actionTwo:) event:200];
      Event *eventOne = [Event newEventWithData:@""];
      Event *eventTwo = [Event newEventWithData:@""];

      [blackboard notify:100 event:eventOne];
      [ExpectObj(watcher.evtAction) toBe:eventOne];

      [blackboard notify:200 event:eventTwo];
      [ExpectObj(watcher.evtActionTwo) toBe:eventTwo];
    });

    It(@"can handle events that aren't action", ^{
      TestWatcher *watcher = [TestWatcher new];
      GameBlackboard *blackboard = [GameBlackboard sharedBlackboard];

      [blackboard registerWatcher:watcher action:@selector(actionTwo:) event:100];
      Event *event = [Event newEventWithData:@""];

      [blackboard notify:100 event:event];

      [ExpectObj(watcher.evtActionTwo) toBe:event];
    });

    It(@"writes to all the registered watchers", ^{
      TestWatcher *watcher = [TestWatcher new];
      TestWatcher *watcherTwo = [TestWatcher new];
      GameBlackboard *blackboard = [GameBlackboard sharedBlackboard];

      [blackboard registerWatcher:watcher action:@selector(action:) event:100];
      [blackboard registerWatcher:watcherTwo action:@selector(action:) event:100];
      Event *event = [Event newEventWithData:@""];

      [blackboard notify:100 event:event];

      [ExpectObj(watcher.evtAction) toBe:event];
      [ExpectObj(watcherTwo.evtAction) toBe:event];
    });

    It(@"allows clearing of the registered watchers", ^{
      TestWatcher *watcher = [TestWatcher new];
      GameBlackboard *blackboard = [GameBlackboard sharedBlackboard];

      [blackboard registerWatcher:watcher action:@selector(actionTwo:) event:100];
      [blackboard clear];

      Event *event = [Event newEventWithData:@""];
      [blackboard notify:100 event:event];

      [ExpectObj(watcher.evtActionTwo) toBeNil];
    });
  });
}