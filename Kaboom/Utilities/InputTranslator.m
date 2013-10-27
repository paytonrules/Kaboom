#include "InputTranslator.h"

@interface InputTranslator()

@property(assign) int width;
@property(strong) NSMutableDictionary *touches;

-(void) updateTouch:(id<NSObject>) touch to:(CGPoint) location;
-(NSValue *) hashValueFor:(id<NSObject>) obj;
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

-(void)newTouch:(id<NSObject>)touch at:(CGPoint)location
{
  [self updateTouch:touch to:location];
}

-(void) moveTouch:(id<NSObject>)touch to:(CGPoint)location
{
  [self updateTouch:touch to:location];
}

-(void) updateTouch:(id<NSObject>) obj to:(CGPoint) location
{
  self.touches[[self hashValueFor:obj]] = [NSValue valueWithCGPoint:location];
}

-(void) removeTouch:(id<NSObject>)touch
{
  [self.touches removeObjectForKey:[self hashValueFor:touch]];
}

-(NSValue *) hashValueFor:(id<NSObject>) obj
{
  NSUInteger hash = [obj hash];
  return [NSValue valueWithBytes:&hash objCType:@encode(NSUInteger)];
}
@end