#import <OCDSpec2/OCDSpec2.h>
#import "Utility.h"

OCDSpec2Context(UtilitySpec) {

  Describe(@"Scaling the point", ^{

    It(@"Doesn't change the scale if the dimensions are the design size", ^{
      CGPoint point = CGPointMake(100, 200);
      CGPoint scaledPoint = [Utility scalePoint:point toDimensions:[Utility designSize]];

      [ExpectInt(scaledPoint.x) toBe:100];
      [ExpectInt(scaledPoint.y) toBe:200];
    });

    It(@"Scales up for larger designs", ^{
      CGPoint point = CGPointMake(100, 200);
      CGSize largerSize = CGSizeMake([Utility designSize].width * 2, [Utility designSize].height * 2);

      CGPoint scaledPoint = [Utility scalePoint:point toDimensions:largerSize];

      [ExpectInt(scaledPoint.x) toBe:200];
      [ExpectInt(scaledPoint.y) toBe:400];
    });


  });
}