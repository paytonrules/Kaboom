
enum {
  kBombDropped,
  kBombCaught,
  kBombHit,
  kGameOver
};

@interface Event : NSObject

+(id) newEventWithData:(id) data;
@property(readonly) id data;

@end
