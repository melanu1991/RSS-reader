#import <Foundation/Foundation.h>

@interface VAKSKPSMTPMessageService : NSObject

+ (instancetype)sharedSKPSMTPMessageService;

- (void)sendMessage:(NSString *)message fromEmail:(NSString *)fromEmail toEmail:(NSString *)toEmail subject:(NSString *)subject;

@end
