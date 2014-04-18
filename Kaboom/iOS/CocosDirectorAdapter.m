#import <cocos2d/cocos2d.h>
#import <UIKit/UIKit.h>
#import "CCScene+SupportsAuthentication.h"
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

-(void) pause
{
  [self.director pause];
}

-(void) presentViewController:(UIViewController *)cont
{
  [self.director presentViewController:cont animated:YES completion:^{}];
}

-(BOOL) supportsAuthentication
{
  return [[self.director runningScene] supportsAuthentication];
}

@end
