#import <Foundation/Foundation.h>

@interface VAKNetManager : NSObject

+ (instancetype)sharedManager;
- (void)loadDataWithPath:(NSString *)path;

@end
