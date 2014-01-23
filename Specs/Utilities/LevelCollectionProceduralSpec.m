#import <OCDSpec2/OCDSpec2.h>
#import "LevelCollectionProcedural.h"
#import "Level.h"

OCDSpec2Context(LevelCollectionProcedural) {

  Describe(@"procedurally generating the levels", ^{

    It(@"starts with the initial level", ^{
      NSObject<LevelCollection> *collection = [LevelCollectionProcedural newWithSpeed:3.0 andBombs:10];

      Level *level = [collection current];

      [ExpectFloat(level.speed) toBe:3.0 withPrecision:0.001];
      [ExpectInt(level.bombs) toBe:10];
    });

    It(@"advances linearly", ^{
      NSObject<LevelCollection> *collection = [LevelCollectionProcedural newWithSpeed:3.0 andBombs:10];

      [collection next];
      Level *level = [collection current];

      [ExpectFloat(level.speed) toBe:6.0 withPrecision:0.001];
      [ExpectInt(level.bombs) toBe:15];

      [collection next];
      level = [collection current];

      [ExpectFloat(level.speed) toBe:9.0 withPrecision:0.001];
      [ExpectInt(level.bombs) toBe:20];
    });

  });

}