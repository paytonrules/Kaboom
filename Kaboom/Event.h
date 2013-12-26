
enum {
  kBombDropped,
  kBombCaught,
  kBombHit
};

@interface Event : NSObject

+(id) newEventWithData:(id) data;
@property(readonly) id data;

@end
