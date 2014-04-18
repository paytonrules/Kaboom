#import "CCLayer+DontSupportAuthentication.h"

@implementation CCLayer(DontSupportAuthentication)

-(BOOL) supportsAuthentication
{
  return NO;
}

@end