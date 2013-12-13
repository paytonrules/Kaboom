#import "KaboomPresenter.h"
#import "Kaboom.h"
#import "NullBomber.h"

@interface KaboomPresenter()

@property(strong) Kaboom *game;
@property(strong) NSObject<Bomber> *bomber;
@property(strong) NSArray *createdBombs;
@property(strong) NSObject<Bomber> *previousFramesBombs;

@end

@implementation KaboomPresenter

+(id) newPresenterWithGame:(Kaboom *)game
{
  return [self newPresenterWithGame:game bomber:[NullBomber new]];
}

+(id) newPresenterWithBomber:(NSObject<Bomber> *) bomber
{
  return [self newPresenterWithGame:[Kaboom new] bomber:bomber];
}

+(id) newPresenterWithGame:(Kaboom *)game bomber:(NSObject<Bomber> *) bomber
{
  KaboomPresenter *presenter = [KaboomPresenter new];
  presenter.game = game;
  presenter.bomber = bomber;
  return presenter;
}

-(void) start
{
  [self.game start];
}

-(void) update:(CGFloat)delta
{
  [self.game update:delta];

  // Check the difference
  self.createdBombs = self.bomber.bombs;


  self.previousFramesBombs = self.bomber.bombs;
}

-(void) tilt:(UIAccelerationValue)acceleration
{

}

-(void) explosionStarted
{

}
@end