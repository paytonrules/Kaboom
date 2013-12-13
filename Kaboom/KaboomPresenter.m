#import "KaboomPresenter.h"
#import "Kaboom.h"

@interface KaboomPresenter()

@property(strong) Kaboom *game;

@end

@implementation KaboomPresenter

+(id) newPresenterWithGame:(Kaboom *)game
{
  KaboomPresenter *presenter = [KaboomPresenter new];
  presenter.game = game;
  return presenter;
}

-(void) start
{
  [self.game start];
}

-(void) update:(CGFloat)delta
{
  [self.game update:delta];
}

-(void) tilt:(UIAccelerationValue)acceleration
{

}

-(void) explosionStarted
{

}
@end