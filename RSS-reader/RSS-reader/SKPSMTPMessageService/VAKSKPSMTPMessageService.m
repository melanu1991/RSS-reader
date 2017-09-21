#import "VAKSKPSMTPMessageService.h"
#import <skpsmtpmessage/SKPSMTPMessage.h>
#import <skpsmtpmessage/NSData+Base64Additions.h>

@interface VAKSKPSMTPMessageService ()

@property (strong, nonatomic) SKPSMTPMessage *sKPSMTPMessage;

@end

@implementation VAKSKPSMTPMessageService

#pragma mark - Implementation Singleton

+ (instancetype)sharedSKPSMTPMessageService {
    static VAKSKPSMTPMessageService *sharedMessageService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMessageService = [[self alloc] init];
    });
    return sharedMessageService;
}

#pragma mark - initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sKPSMTPMessage = [[SKPSMTPMessage alloc] init];
        self.sKPSMTPMessage.relayHost = @"smtp.gmail.com";
        self.sKPSMTPMessage.requiresAuth = YES;
        self.sKPSMTPMessage.login = @"myRSSTestAcc@gmail.com";
        self.sKPSMTPMessage.pass = @"myPassword";
        self.sKPSMTPMessage.wantsSecure = YES;
    }
    return self;
}

#pragma mark - Implementation method send email

- (void)sendMessage:(NSString *)message fromEmail:(NSString *)fromEmail toEmail:(NSString *)toEmail subject:(NSString *)subject {
    self.sKPSMTPMessage.fromEmail = fromEmail;
    self.sKPSMTPMessage.toEmail = toEmail;
    self.sKPSMTPMessage.subject = subject;
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",
                               kSKPSMTPPartContentTypeKey,
                               [message stringByAppendingString:[NSString stringWithFormat:@"\nFrom email: %@", fromEmail]],
                               kSKPSMTPPartMessageKey,
                               @"8bit",
                               kSKPSMTPPartContentTransferEncodingKey,
                               nil];
    NSArray *parts = @[plainPart];
    self.sKPSMTPMessage.parts = parts;
    [self.sKPSMTPMessage send];
}

@end
