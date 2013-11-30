#import "Bomber2D.h"
#import "Constants.h"
#import "Bomb2D.h"
#import "Buckets.h"

@interface Bomber2D ()
@property(assign) CGPoint position;
@property(assign) float speed;
@property(strong) NSObject<LocationChooser> *locations;
@property(assign) float location;
@property(assign) int height;
@property(assign) int bombHeight;
@property(strong) NSMutableArray *droppedBombs;
@property(assign) BOOL exploding;

-(void) updateBombs;
@end

@implementation Bomber2D

-(id)init
{
  return [self initWithPosition:CGPointMake(0, 0)
                locationChooser:nil
                         height:0
                     bombHeight:0];
}

-(id) initWithPosition:(CGPoint)position locationChooser:(NSObject <LocationChooser> *)locations
{
  return [self initWithPosition:position
                locationChooser:locations
                         height:0
                     bombHeight:0];
}

-(id) initWithPosition:(CGPoint)position locationChooser:(NSObject <LocationChooser> *)locations height:(int)height bombHeight:(int)bombHeight
{
  if (self = [super init])
  {
    self.position = position;
    self.locations = locations;
    self.height = height;
    self.bombHeight = bombHeight;
    self.droppedBombs = [NSMutableArray new];
    self.speed = 0;
  }
  return self;
}

-(void) explode
{
  self.droppedBombs = [NSMutableArray new];
}

-(int) bombCount
{
  return self.bombs.count;
}

-(NSArray *)bombs
{
  return [NSArray arrayWithArray: self.droppedBombs];
}

-(void) startAtSpeed:(float) speed withBombs:(int) count
{
  self.location = [self.locations next];
  self.speed = speed;
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
  NSObject<Bomb> *bomb = [Bomb2D bombAtX:self.position.x y:self.position.y - (self.height / 2) - (self.bombHeight / 2)];
  [self.droppedBombs addObject:bomb];
}

-(void) updateBombs
{
  for (NSObject<Bomb> *bomb in self.droppedBombs)
  {
    bomb.position = CGPointMake(bomb.position.x, bomb.position.y - kGravity);
  }
}

-(NSInteger) checkBombs:(Buckets *)buckets
{
  int caughtBombs = 0;
  NSMutableArray *remainingBombs = [NSMutableArray new];
  for (NSObject<Bomb> *bombPosition in self.droppedBombs)
  {
    if (![buckets caughtBomb:bombPosition])
    {
      [remainingBombs addObject:bombPosition];
    }
    else
    {
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