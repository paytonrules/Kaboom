#import "Bomber.h"
#import "Constants.h"

@interface Bomber()
@property(assign) CGPoint position;
@property(assign) float speed;
@property(strong) NSObject<LocationChooser> *locations;
@property(assign) float location;
@property(assign) BOOL started;
@property(assign) int height;
@property(assign) int bombHeight;
@property(strong) NSMutableArray *droppedBombs;

-(void) updateBombs;
-(void) addNewBomb;
@end

@implementation Bomber

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

-(void)update:(float)deltaTime
{
  if (self.started)
  {
    float moveDistance = self.speed * deltaTime;
    float distanceRemaining = abs(self.location - self.position.x);

    if (self.location > self.position.x) {
      self.position = CGPointMake(self.position.x + moveDistance, self.position.y);
    }
    else {
      self.position = CGPointMake(self.position.x - moveDistance, self.position.y);
    }

    [self updateBombs];

    if (moveDistance >= distanceRemaining) {
      [self addNewBomb];
    }
  }
}

-(void) addNewBomb
{
  CGPoint bombLocation = CGPointMake(self.position.x, self.position.y + (self.height / 2) + (self.bombHeight / 2));
  [self.droppedBombs addObject:[NSValue valueWithBytes:&bombLocation objCType:@encode(CGPoint)]];

  self.location = [self.locations next];
}

-(void) updateBombs
{
  NSMutableArray *newBombs = [NSMutableArray new];
  for (NSValue *bombPosition in self.droppedBombs)
  {
    CGPoint bombLocation;
    [bombPosition getValue:&bombLocation];

    bombLocation = CGPointMake(bombLocation.x, bombLocation.y - kGravity);
    [newBombs addObject:[NSValue valueWithBytes:&bombLocation objCType:@encode(CGPoint)]];
  }
  self.droppedBombs = newBombs;
}
@end