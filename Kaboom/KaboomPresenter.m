#import "KaboomPresenter.h"
#import "Kaboom.h"
#import "NullBomber.h"
#import "GameBlackboard.h"
#import "Event.h"

@interface KaboomPresenter()

@property(strong) Kaboom *game;
@property(strong) NSObject<Bomber> *bomber;
@property(strong) NSArray *createdBombs;
@property(assign) BOOL exploding;
@end

@implementation KaboomPresenter

+(id) newPresenterWithGame:(Kaboom *)game
{
  return [self newPresenterWithGame:game bomber:[NullBomber new]];
}

+(id) newPresenterWithGame:(Kaboom *)game bomber:(NSObject<Bomber> *) bomber
{
  KaboomPresenter *presenter = [KaboomPresenter new];
  presenter.game = game;
  presenter.bomber = bomber;
  return presenter;
}

-(id) init {
  if (self = [super init]) {
    [[GameBlackboard sharedBlackboard] registerWatcher:self action:@selector(addBomb:) event:kBombDropped];
    self.createdBombs = [NSArray array];
  }
  return self;
}

-(void) start
{
  [self.game start];
}

-(void) update:(CGFloat)delta
{
  if (!self.exploding) {
    self.createdBombs = [NSArray array];
    [self.game update:delta];
  }
}

-(void) addBomb:(Event *)evt
{
  self.createdBombs = [self.createdBombs arrayByAddingObject:evt.data];
}

-(void) tilt:(float)acceleration
{
  [self.game tilt:acceleration];
}

-(void) explosionStarted
{
  self.exploding = YES;
}
@end