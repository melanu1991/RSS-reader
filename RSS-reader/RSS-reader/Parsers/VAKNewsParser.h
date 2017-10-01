#import <Foundation/Foundation.h>

@interface VAKNewsParser : NSObject

+ (void)newsWithData:(NSArray *)data identifierUrlChannel:(NSUInteger)identifierUrlChannel completionBlock:(void(^)(void))completionBlock;

@end
