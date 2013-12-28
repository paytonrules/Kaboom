#import <Foundation/Foundation.h>

@interface LevelCollection : NSObject

+(id) newWithArray:(NSArray *) levels;

- (NSDictionary *)next;
@end