#include "InputTranslator.h"

@interface InputTranslator()

@property(assign) int width;
@property(strong) NSMutableDictionary *touches;

@end

@implementation InputTranslator

+(id) newTranslatorWithWidth:(int)width
{
  InputTranslator *trans = [InputTranslator new];
  trans.width = width;
  return trans;
}

-(id) init {
  if (self = [super init])
  {
    self.touches = [NSMutableDictionary new];
  }

  return self;
}

-(int) movement
{
  __block int movement = 0;
  [self.touches enumerateKeysAndObjectsUsingBlock:^(id touch, id locationValue, BOOL *stop) {
    CGPoint point;
    [locationValue getValue:&point];

    if (point.x >= (self.width / 2))
      movement++;
    else
      movement--;
  }];

  return movement;
}

-(void)newTouch:(id)touch at:(CGPoint)location
{
  NSUInteger hash = [touch hash];
  NSValue *hashAsValue = [NSValue valueWithBytes:&hash objCType:@encode(NSUInteger)];
  self.touches[hashAsValue] = [NSValue valueWithCGPoint:location];
}

-(void) newTouch:(id)touch inView:(id)view
{
  self.touches[touch] = [NSValue valueWithCGPoint:[touch locationInView:view]];
}
@end