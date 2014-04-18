#import <cocos2d/CCLayer.h>
#import "CCScene+SupportsAuthentication.h"
#import "CCLayer+DontSupportAuthentication.h"

@implementation CCScene(SupportsAuthentication)

-(BOOL) supportsAuthentication {
  CCLayer *layer = [[self children] objectAtIndex:0];
  return [layer supportsAuthentication];
}

@end