#import <OCDSpec2/OCDSpec2.h>
#import "Bomb2D.h"

OCDSpec2Context(Bomb2DSpec) {

  Describe(@"The bomb hits", ^{

    It(@"is not a hit if it has no bounding box", ^{
      Bomb2D *bomb = [Bomb2D new];

      [ExpectBool([bomb hit]) toBeFalse];
    });

    It(@"is a hit if it's bottom-most bit is below 0", ^{
      Bomb2D *bomb = [Bomb2D new];
      bomb.boundingBox = CGRectMake(1, 10, 1, 11);

      [ExpectBool([bomb hit]) toBeTrue];
    });

    It(@"is not a hit if its bottom-most bit isn't below 0", ^{
      Bomb2D *bomb = [Bomb2D new];
      bomb.boundingBox = CGRectMake(1, 10, 1, 6);

      [ExpectBool([bomb hit]) toBeFalse];
    });

  });
}