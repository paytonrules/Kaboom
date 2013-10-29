#include "InputTranslator.h"

@interface InputValue : NSObject
@property(assign) CGPoint location;
@property(assign) int updates;
@end

@implementation InputValue
@end

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

-(float) tilt
{
  __block float movement = 0;
  [self.touches enumerateKeysAndObjectsUsingBlock:^(id touch, InputValue *input, BOOL *stop) {
    if (input.location.x >= (self.width / 2))
      movement += input.updates * 0.01;
    else
      movement -= input.updates * 0.01;
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
  InputValue *value = [InputValue new];
  value.location = location;
  value.updates = 1;
  self.touches[[self hashValueFor:obj]] = value;
}

-(void) update
{
  [self.touches enumerateKeysAndObjectsUsingBlock:^(id key, InputValue *input, BOOL *stop) {
    input.updates++;
  }];
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