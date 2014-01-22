#import <OCDSpec2/OCDSpec2.h>
#import "LevelCollectionArray.h"

OCDSpec2Context(LevelCollection) {

  Describe(@"A level collection with iterator", ^{

    It(@"returns the first level", ^{
      LevelCollectionArray *collection = [LevelCollectionArray newWithArray:@[@{@"Speed" : @"1"}]];

      NSDictionary *first = [collection current];

      [ExpectObj(first) toBeEqualTo:@{@"Speed" : @"1"}];
    });

    It(@"advances using the next iterator", ^{
      LevelCollectionArray *collection = [LevelCollectionArray newWithArray:@[@{@"Speed" : @"1"}, @{@"Speed" : @"2"}]];

      [collection next];
      NSDictionary *next = [collection current];

      [ExpectObj(next) toBeEqualTo:@{@"Speed" : @"2"}];
    });

    It(@"returns last entry in the list when you've run out of entries", ^{
      LevelCollectionArray *collection = [LevelCollectionArray newWithArray:@[@{@"Speed" : @"1"}]];

      [collection next];
      NSDictionary *next = [collection current];

      [ExpectObj(next) toBeEqualTo:@{@"Speed" : @"1"}];
    });

    It(@"returns the current entry in the list", ^{
      LevelCollectionArray *collection = [LevelCollectionArray newWithArray:@[@{@"Speed" : @"1"}, @{@"Speed" : @"2"}]];

      NSDictionary *next = [collection current];

      [ExpectObj(next) toBeEqualTo:@{@"Speed" : @"1"}];
    });
  });
}