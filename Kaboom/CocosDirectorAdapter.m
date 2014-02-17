#import <cocos2d/cocos2d.h>
#import "CocosDirectorAdapter.h"

@interface CocosDirectorAdapter()

@property(strong) CCDirectorIOS *director;

@end

@implementation CocosDirectorAdapter

+(instancetype) newWithCocosDirector:(CCDirectorIOS *)director
{
  CocosDirectorAdapter *adapter = [CocosDirectorAdapter new];
  adapter.director = director;
  return adapter;
}

-(void) resume
{
  [self.director resume];
}

@end
