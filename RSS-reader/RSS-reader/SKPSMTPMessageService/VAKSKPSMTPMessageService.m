#import "VAKSKPSMTPMessageService.h"
#import <skpsmtpmessage/SKPSMTPMessage.h>
#import <skpsmtpmessage/NSData+Base64Additions.h>

static NSString * const VAKSMTPServer = @"smtp.gmail.com";
static NSString * const VAKSMTPServerLogin = @"myRSSTestAcc@gmail.com";
static NSString * const VAKSMTPServerPassword = @"myPassword";

@interface VAKSKPSMTPMessageService () <SKPSMTPMessageDelegate>

@property (strong, nonatomic) SKPSMTPMessage *sKPSMTPMessage;

@end

@implementation VAKSKPSMTPMessageService

#pragma mark - Lazy getters

- (SKPSMTPMessage *)sKPSMTPMessage {
    if (!_sKPSMTPMessage) {
        self.sKPSMTPMessage = [[SKPSMTPMessage alloc] init];
        self.sKPSMTPMessage.relayHost = VAKSMTPServer;
        self.sKPSMTPMessage.requiresAuth = YES;
        self.sKPSMTPMessage.login = VAKSMTPServerLogin;
        self.sKPSMTPMessage.pass = VAKSMTPServerPassword;
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
    
    NSString *fromEmail = info[VAKFromEmailInfo];
    NSString *phoneNumber = info[VAKPhoneNumberInfo];
    NSArray *images = info[VAKImagesInfo];
    __unused NSArray *files = info[VAKFilesInfo];
    
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
    self.sKPSMTPMessage = nil;
    [self.delegate confirmOfSendingMessage:nil];
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error {
    self.sKPSMTPMessage = nil;
    [self.delegate confirmOfSendingMessage:error];
}

@end
