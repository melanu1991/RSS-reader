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

- (void)sendMessage:(NSString *)message toEmail:(NSString *)toEmail subject:(NSString *)subject info:(NSDictionary *)info {
    
    NSString *fromEmail = info[@"VAKFromEmail"];
    NSString *phoneNumber = info[@"VAKPhoneNumber"];
    NSArray *images = info[@"VAKImages"];
    __unused NSArray *files = info[@"VAKFiles"];
    
    self.sKPSMTPMessage.fromEmail = fromEmail;
    self.sKPSMTPMessage.toEmail = toEmail;
    self.sKPSMTPMessage.subject = subject;
    
    NSMutableString *fullMessage = [NSMutableString string];
    if (fromEmail) {
        [fullMessage appendString:[NSString stringWithFormat:@"\nFrom email: %@", fromEmail]];
    }
    if (phoneNumber) {
        [fullMessage appendString:[NSString stringWithFormat:@"\nPhone number: %@", phoneNumber]];
    }
    
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",
                               kSKPSMTPPartContentTypeKey,
                               fullMessage,
                               kSKPSMTPPartMessageKey,
                               @"8bit",
                               kSKPSMTPPartContentTransferEncodingKey,
                               nil];
    
    NSMutableArray *parts = [NSMutableArray array];
    [parts addObject:plainPart];
    
    NSInteger index = 0;
    for (UIImage *image in images) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
        NSString *strFileName = [NSString stringWithFormat:@"MyPicture-%ld.jpeg", ++index];
        
        NSString *strFormat = [NSString stringWithFormat:@"image/jpeg;\r\n\tx-unix-mode=0644;\r\n\tname=\"%@\"",strFileName];
        NSString *strFormat2 = [NSString stringWithFormat:@"attachment;\r\n\tfilename=\"%@\"",strFileName];
        NSDictionary *vcfPart = [NSDictionary dictionaryWithObjectsAndKeys:strFormat,kSKPSMTPPartContentTypeKey,
                                 strFormat2,kSKPSMTPPartContentDispositionKey,[imageData encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
        [parts addObject:vcfPart];
    }
    
    self.sKPSMTPMessage.parts = parts;
    [self.sKPSMTPMessage send];
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
