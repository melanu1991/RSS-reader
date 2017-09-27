#import <Foundation/Foundation.h>

@class UIImage;

@interface VAKNetManager : NSObject

+ (instancetype)sharedManager;

- (void)loadDataWithPath:(NSString *)path completionHandler:(void(^)(NSArray *data, NSError *error))completionHandler;
- (void)loadImageWithPath:(NSString *)path completionBlock:(void(^)(NSData *imageData, NSError *error))completionBlock;

@end
