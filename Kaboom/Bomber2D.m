#import "Bomber2D.h"
#import "Constants.h"
#import "Bomb2D.h"
#import "Buckets.h"
#import "GameBlackboard.h"
#import "Event.h"

@interface Bomber2D()
{
  int _height;
}

@property(assign) CGPoint position;
@property(assign) float speed;
@property(strong) NSObject<LocationChooser> *locations;
@property(assign) float location;
@property(strong) NSMutableArray *droppedBombs;
@property(assign) BOOL exploding;
@property(assign) int bombCount;

-(void) updateBombs;
@end

@implementation Bomber2D

-(id)init
{
  return [self initWithPosition:CGPointZero locationChooser:nil];
}

-(id) initWithPosition:(CGPoint)position locationChooser:(NSObject <LocationChooser> *)locations
{
  if (self = [super init])
  {
    self.droppedBombs = [NSMutableArray new];
    self.locations = locations;
    self.position = position;
  }
  return self;
}

-(void) setHeight:(int) height
{
  _height = height;
  self.position = CGPointMake(self.position.x, GAME_HEIGHT - height);
}

-(int) height
{
  return _height;
}

-(void) explode
{
  self.droppedBombs = [NSMutableArray new];
  self.exploding = YES;
}

-(int) droppedBombCount
{
  return self.bombs.count;
}

-(BOOL) isOut
{
  return self.bombCount == 0 && self.droppedBombs.count == 0;
}

-(NSArray *)bombs
{
  return [NSArray arrayWithArray: self.droppedBombs];
}

-(void) startAtSpeed:(float) speed withBombs:(int) count
{
  self.location = [self.locations next];
  self.speed = speed;
  self.exploding = NO;
  self.bombCount = count;
}

-(void) update:(float)deltaTime
{
  if (self.speed > 0)
  {
    float moveDistance = self.speed * deltaTime;
    float distanceRemaining = abs(self.location - self.position.x);

    if (self.location > self.position.x) {
      [self move:moveDistance];
    }
    else {
      [self move:-moveDistance];
    }

    [self updateBombs];

    if (moveDistance >= distanceRemaining) {
      [self dropBomb];
      self.location = [self.locations next];
    }
  }
}

-(void) move:(float)amount
{
  self.position = CGPointMake(self.position.x + amount, self.position.y);
}

-(void) dropBomb
{
  NSObject<Bomb> *bomb = [Bomb2D bombAtX:self.position.x y:self.position.y - (self.height / 2)];
  [self.droppedBombs addObject:bomb];
  self.bombCount--;
  [[GameBlackboard sharedBlackboard] notify:kBombDropped event:[Event newEventWithData:bomb]];
}

-(void) updateBombs
{
  for (NSObject<Bomb> *bomb in self.droppedBombs)
  {
    bomb.position = CGPointMake(bomb.position.x, bomb.position.y - kGravity);
  }
}

-(NSInteger)updateDroppedBombs:(Buckets *)buckets
{
  int caughtBombs = 0;
  NSMutableArray *remainingBombs = [NSMutableArray new];
  for (NSObject<Bomb> *bomb in self.droppedBombs)
  {
    if (![buckets caughtBomb:bomb])
    {
      [remainingBombs addObject:bomb];
    }
    else
    {
      [[GameBlackboard sharedBlackboard] notify:kBombCaught event:[Event newEventWithData:bomb]];
      caughtBombs++ ;
    }
  }

  self.droppedBombs = [NSMutableArray arrayWithArray:remainingBombs];
  return caughtBombs;
}

-(BOOL) bombHit
{
  __block BOOL bombHit = false;
  [self.droppedBombs enumerateObjectsUsingBlock:^(NSObject<Bomb> *bomb, NSUInteger idx, BOOL *stop) {
    if ([bomb hit]) {
      bombHit = YES;
      *stop = YES;
    }
  }];
  return bombHit;
}

@end