#import <Foundation/Foundation.h>

@class UIImage;

@interface VAKNetManager : NSObject

+ (instancetype)sharedManager;

- (void)loadDataWithPath:(NSString *)path completionBlock:(void(^)(NSArray *data, NSError *error))completionBlock;
- (void)loadImageWithPath:(NSString *)path completionBlock:(void(^)(NSData *imageData, NSError *error))completionBlock;

@end
