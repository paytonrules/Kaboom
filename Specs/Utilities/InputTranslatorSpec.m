#import <OCDSpec2/OCDSpec2.h>
#import "InputTranslator.h"


OCDSpec2Context(InputTranslatorSpec) {
  __block InputTranslator *trans;
  __block UITouch *touch;

  Describe(@"Translate touches to movement", ^{

    BeforeEach(^{
      touch = [[UITouch alloc] init];
    });

    It(@"Returns no movement when there are no touches", ^{
      trans = [InputTranslator new];

      [ExpectInt(trans.movement) toBe:0];
    });

    It(@"Returns one movement when one touch is registered on the right side of the screen", ^{
      trans = [InputTranslator newTranslatorWithWidth:100];

      [trans newTouch:touch at:CGPointMake(51, 0)];

      [ExpectInt(trans.movement) toBe:1];
    });

    It(@"returns -1 movement when one touch is registered on the right side of the screen", ^{
      trans = [InputTranslator newTranslatorWithWidth:100];

      [trans newTouch:touch at:CGPointMake(49, 0)];

      [ExpectInt(trans.movement) toBe:-1];
    });

    It(@"returns 1 movement when the touch is right on the center - so it still moves", ^{
      trans = [InputTranslator newTranslatorWithWidth:100];

      [trans newTouch:touch at:CGPointMake(50, 0)];

      [ExpectInt(trans.movement) toBe:1];
    });

    It(@"accumlates multiple touches", ^{
      UITouch *touchTwo = [UITouch new];
      trans = [InputTranslator newTranslatorWithWidth:100];

      CGPoint touchLocationOne = CGPointMake(50, 0);
      CGPoint touchLocationTwo = CGPointMake(51, 0);

      [trans newTouch:touch at:touchLocationOne];
      [trans newTouch:touchTwo at:touchLocationTwo];
      [ExpectInt(trans.movement) toBe:2];
    });
  });
}