#import <Foundation/Foundation.h>

@interface InputTranslator : NSObject

@property(readonly) int movement;

+ (id)newTranslatorWithWidth:(int)width;

- (void)newTouch:(id)touch inView:(id)view;
-(void)newTouch:(id)touch at:(CGPoint)location;
@end