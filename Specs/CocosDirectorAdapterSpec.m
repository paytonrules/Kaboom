#import <OCDSpec2/OCDSpec2.h>
#import <cocos2d/cocos2d.h>
#import "CocosDirectorAdapter.h"
#import "CCDirectorIOS+Tracking.h"

OCDSpec2Context(CocosDirectorAdapterSpec) {
  
  Describe(@"Adapting the Cocos Director", ^{
    
    It(@"Passes along resume", ^{
      CCDirectorIOS *director = [CCDirectorIOS new];
      CocosDirectorAdapter *adapter = [CocosDirectorAdapter newWithCocosDirector:director];
      
      [adapter resume];
      
      [ExpectBool(director.playing) toBeTrue];
    });
    
  });
  
}
