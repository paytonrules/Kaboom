#import <OCDSpec2/OCDSpec2.h>
#import "InputTranslator.h"


OCDSpec2Context(InputTranslatorSpec) {
  __block InputTranslator *trans;
  __block UITouch *touch;

  Describe(@"Translate touches to tilt", ^{

    BeforeEach(^{
      touch = [[UITouch alloc] init];
    });

    It(@"Returns no tilt when there are no touches", ^{
      trans = [InputTranslator new];

      [ExpectFloat(trans.tilt) toBe:0 withPrecision:0.001];
    });

    It(@"Starts tilting right one touch is registered on the right side of the screen", ^{
      trans = [InputTranslator newTranslatorWithWidth:100];

      [trans newTouch:touch at:CGPointMake(51, 0)];

      [ExpectFloat(trans.tilt) toBe:0.01 withPrecision:0.001];
    });

    It(@"returns -1.0 tilt when one touch is registered on the left side of the screen", ^{
      trans = [InputTranslator newTranslatorWithWidth:100];

      [trans newTouch:touch at:CGPointMake(49, 0)];

      [ExpectFloat(trans.tilt) toBe:-0.01 withPrecision:0.001];
    });

    It(@"returns 1.0 tilt when the touch is right on the center - so it still moves", ^{
      trans = [InputTranslator newTranslatorWithWidth:100];

      [trans newTouch:touch at:CGPointMake(50, 0)];

      [ExpectFloat(trans.tilt) toBe:0.01 withPrecision:0.001];
    });

    It(@"accumlates multiple touches", ^{
      UITouch *touchTwo = [UITouch new];
      trans = [InputTranslator newTranslatorWithWidth:100];

      CGPoint touchLocationOne = CGPointMake(50, 0);
      CGPoint touchLocationTwo = CGPointMake(51, 0);

      [trans newTouch:touch at:touchLocationOne];
      [trans newTouch:touchTwo at:touchLocationTwo];
      [ExpectFloat(trans.tilt) toBe:0.02 withPrecision:0.001];
    });

    It(@"updates a touch when they move", ^{
      trans = [InputTranslator newTranslatorWithWidth:100];

      [trans newTouch:touch at:CGPointMake(51, 0)];
      [trans moveTouch:touch to:CGPointMake(49, 0)];

      [ExpectFloat(trans.tilt) toBe:-0.01 withPrecision:0.001];
    });

    It(@"removes a touch from the tilt calculation", ^{
      trans = [InputTranslator newTranslatorWithWidth:100];

      [trans newTouch:touch at:CGPointMake(51, 0)];
      [trans removeTouch:touch];

      [ExpectFloat(trans.tilt) toBe:0 withPrecision:0.001];
    });

    It(@"increases the tilt on each update if the touch doesn't move", ^{
      trans = [InputTranslator newTranslatorWithWidth:100];

      [trans newTouch:touch at:CGPointMake(51, 0)];
      [trans update];

      [ExpectFloat(trans.tilt) toBe:0.02 withPrecision:0.001];
    });

    It(@"resets the updates when a touch moves", ^{
      trans = [InputTranslator newTranslatorWithWidth:100];

      [trans newTouch:touch at:CGPointMake(51, 0)];
      [trans update];
      [trans update];
      [trans update];
      [trans moveTouch:touch to:CGPointMake(49, 0)];

      [ExpectFloat(trans.tilt) toBe:-0.01 withPrecision:0.001];
    });
  });
}