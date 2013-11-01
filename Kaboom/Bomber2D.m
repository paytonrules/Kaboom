#import "Bomber2D.h"
#import "Constants.h"
#import "Bomb2D.h"

@interface Bomber2D ()
@property(assign) CGPoint position;
@property(assign) float speed;
@property(strong) NSObject<LocationChooser> *locations;
@property(assign) float location;
@property(assign) BOOL started;
@property(assign) int height;
@property(assign) int bombHeight;
@property(strong) NSMutableArray *droppedBombs;

-(void) updateBombs;
@end

@implementation Bomber2D

-(id)init
{
  return [self initWithPosition:CGPointMake(0, 0)
                          speed:0
                locationChooser:nil
                         height:0
                     bombHeight:0];
}

-(id) initWithPosition:(CGPoint)position speed:(float)speed locationChooser:(NSObject <LocationChooser> *)locations
{
  return [self initWithPosition:position
                          speed:speed
                locationChooser:locations
                         height:0
                     bombHeight:0];

}

-(id) initWithPosition:(CGPoint)position speed:(float)speed locationChooser:(NSObject <LocationChooser> *)locations height:(int)height bombHeight:(int)bombHeight
{
  if (self = [super init])
  {
    self.position = position;
    self.speed = speed;
    self.locations = locations;
    self.height = height;
    self.bombHeight = bombHeight;
    self.droppedBombs = [NSMutableArray new];
  }
  return self;
}

-(int) bombCount
{
  return self.bombs.count;
}

-(NSArray *)bombs
{
  return [NSArray arrayWithArray: self.droppedBombs];
}

-(void) start
{
  self.location = [self.locations next];
  self.started = YES;
}

-(void) update:(float)deltaTime
{
  if (self.started)
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
  NSObject<Bomb> *bomb = [Bomb2D bombAtX:self.position.x y:self.position.y + (self.height / 2) + (self.bombHeight / 2)];
  [self.droppedBombs addObject:bomb];
}

-(void) updateBombs
{
  for (NSObject<Bomb> *bomb in self.droppedBombs)
  {
    bomb.position = CGPointMake(bomb.position.x, bomb.position.y - kGravity);
  }
}

-(void) checkBombs:(NSObject<Buckets> *)buckets
{
  NSMutableArray *remainingBombs = [NSMutableArray new];
  for (NSObject<Bomb> *bombPosition in self.droppedBombs)
  {
    if (![buckets caughtBomb:bombPosition])
    {
      [remainingBombs addObject:bombPosition];
    }
  }

  self.droppedBombs = [NSMutableArray arrayWithArray:remainingBombs];
}
@end