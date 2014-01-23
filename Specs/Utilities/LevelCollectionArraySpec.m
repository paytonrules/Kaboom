#import <OCDSpec2/OCDSpec2.h>
#import "LevelCollectionArray.h"
#import "Level.h"

OCDSpec2Context(LevelCollectionArray) {

  Describe(@"A level collection with iterator", ^{

    It(@"returns the first level", ^{
      LevelCollectionArray *collection = [LevelCollectionArray newWithArray:@[@{@"Speed" : @"1"}]];

      Level *first = [collection current];

      [ExpectFloat(first.speed) toBe:1.0 withPrecision:0.01];
    });

    It(@"advances using the next iterator", ^{
      LevelCollectionArray *collection = [LevelCollectionArray newWithArray:@[@{@"Speed" : @"1"}, @{@"Speed" : @"2"}]];

      [collection next];
      Level *next = [collection current];

      [ExpectFloat(next.speed) toBe:2.0 withPrecision:0.001];
    });

    It(@"returns last entry in the list when you've run out of entries", ^{
      LevelCollectionArray *collection = [LevelCollectionArray newWithArray:@[@{@"Speed" : @"1"}]];

      [collection next];
      Level *next = [collection current];

      [ExpectFloat(next.speed) toBe:1.0 withPrecision:0.001];
    });

    It(@"returns the current entry in the list", ^{
      LevelCollectionArray *collection = [LevelCollectionArray newWithArray:@[@{@"Speed" : @"1"}, @{@"Speed" : @"2"}]];

      Level *next = [collection current];

      [ExpectFloat(next.speed) toBe:1.0 withPrecision:0.001];
    });

    It(@"also loads up the bombs", ^{
      LevelCollectionArray *collection = [LevelCollectionArray newWithArray:@[@{@"Bombs" : @"10"}]];

      Level *next = [collection current];

      [ExpectInt(next.bombs) toBe:10];
    });
  });
}