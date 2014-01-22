#import <OCDSpec2/OCDSpec2.h>
#import "LevelCollection.h"

OCDSpec2Context(LevelCollection) {

  Describe(@"A level collection with iterator", ^{

    It(@"returns the first level", ^{
      LevelCollection *collection = [LevelCollection newWithArray:@[@{@"Speed" : @"1"}]];

      NSDictionary *first = [collection current];

      [ExpectObj(first) toBeEqualTo:@{@"Speed" : @"1"}];
    });

    It(@"advances using the next iterator", ^{
      LevelCollection *collection = [LevelCollection newWithArray:@[@{@"Speed" : @"1"}, @{@"Speed" : @"2"}]];

      [collection next];
      NSDictionary *next = [collection current];

      [ExpectObj(next) toBeEqualTo:@{@"Speed" : @"2"}];
    });

    It(@"returns last entry in the list when you've run out of entries", ^{
      LevelCollection *collection = [LevelCollection newWithArray:@[@{@"Speed" : @"1"}]];

      [collection next];
      NSDictionary *next = [collection current];

      [ExpectObj(next) toBeEqualTo:@{@"Speed" : @"1"}];
    });

    It(@"returns the current entry in the list", ^{
      LevelCollection *collection = [LevelCollection newWithArray:@[@{@"Speed" : @"1"}, @{@"Speed" : @"2"}]];

      NSDictionary *next = [collection current];

      [ExpectObj(next) toBeEqualTo:@{@"Speed" : @"1"}];
    });
  });
}