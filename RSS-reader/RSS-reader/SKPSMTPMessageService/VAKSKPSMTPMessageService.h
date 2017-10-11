#import <Foundation/Foundation.h>
#import "VAKSKPSMTPMessageServiceDelegate.h"

static NSString * const VAKFromEmailInfo = @"VAKFromEmail";
static NSString * const VAKPhoneNumberInfo = @"VAKPhoneNumber";
static NSString * const VAKImagesInfo = @"VAKImages";
static NSString * const VAKFilesInfo = @"VAKFiles";

@interface VAKSKPSMTPMessageService : NSObject

+ (instancetype)sharedSKPSMTPMessageService;

- (void)sendMessage:(NSString *)message toEmail:(NSString *)toEmail subject:(NSString *)subject info:(NSDictionary *)info;

@property (weak, nonatomic) id<VAKSKPSMTPMessageServiceDelegate> delegate;

@end
