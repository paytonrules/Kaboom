#import "SizeStrategy.h"

@interface SizeService : NSObject

+(void) setStrategy:(NSObject<SizeStrategy> *) strategy;
+(CGSize) screenSize;

@end
