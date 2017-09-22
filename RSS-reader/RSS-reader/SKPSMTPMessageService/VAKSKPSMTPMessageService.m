#import "VAKSKPSMTPMessageService.h"
#import <skpsmtpmessage/SKPSMTPMessage.h>
#import <skpsmtpmessage/NSData+Base64Additions.h>

@interface VAKSKPSMTPMessageService () <SKPSMTPMessageDelegate>

@property (strong, nonatomic) SKPSMTPMessage *sKPSMTPMessage;

@end

@implementation VAKSKPSMTPMessageService

#pragma mark - Lazy getters

- (SKPSMTPMessage *)sKPSMTPMessage {
    if (!_sKPSMTPMessage) {
        self.sKPSMTPMessage = [[SKPSMTPMessage alloc] init];
        self.sKPSMTPMessage.relayHost = @"smtp.gmail.com";
        self.sKPSMTPMessage.requiresAuth = YES;
        self.sKPSMTPMessage.login = @"myRSSTestAcc@gmail.com";
        self.sKPSMTPMessage.pass = @"myPassword";
        self.sKPSMTPMessage.wantsSecure = YES;
        self.sKPSMTPMessage.delegate = self;
    }
    return _sKPSMTPMessage;
}

#pragma mark - Implementation Singleton

+ (instancetype)sharedSKPSMTPMessageService {
    static VAKSKPSMTPMessageService *sharedMessageService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMessageService = [[self alloc] init];
    });
    return sharedMessageService;
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
    self.sKPSMTPMessage = nil;
}

#pragma mark - SKPSMTPMessageDelegate

- (void)messageSent:(SKPSMTPMessage *)message {
    NSLog(@"%@", @"successful");
    self.sKPSMTPMessage = nil;
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error {
    NSLog(@"%@", @"fail");
    self.sKPSMTPMessage = nil;
}

@end
