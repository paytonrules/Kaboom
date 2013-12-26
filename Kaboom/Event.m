#import "Event.h"

@interface Event()

@property(strong) id data;

@end

@implementation Event

+(id) newEventWithData:(id)data {
  Event *evt = [Event new];
  evt.data = data;
  return evt;
}


@end
