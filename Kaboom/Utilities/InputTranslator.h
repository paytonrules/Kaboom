#import <Foundation/Foundation.h>

@interface InputTranslator : NSObject

@property(readonly) float tilt;

+(id) newTranslatorWithWidth:(int)width;

-(void) newTouch:(id<NSObject>)touch at:(CGPoint)location;
-(void) moveTouch:(id<NSObject>)touch to:(CGPoint)location;
-(void) removeTouch:(id<NSObject>)touch;
-(void) update;
@end