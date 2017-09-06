#import <Foundation/Foundation.h>

@interface VAKNetManager : NSObject

+ (instancetype)sharedManager;
- (void)loadDataWithPath:(NSString *)path completionHandler:(void(^)(NSArray *data, NSError *error))completionHandler;

@end
