#import <Foundation/Foundation.h>

@interface Utility : NSObject

+(CGSize) designSize;
+(CGPoint) scalePoint:(CGPoint) point toDimensions:(CGSize) dimensions;
@end
