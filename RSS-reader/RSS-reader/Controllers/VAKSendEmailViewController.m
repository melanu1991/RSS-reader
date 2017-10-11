#import "VAKSendEmailViewController.h"
#import "VAKNSString+ValidateEmail.h"
#import "VAKUIAlertController+Message.h"
#import "VAKSKPSMTPMessageService.h"
#import "VAKSKPSMTPMessageServiceDelegate.h"

static NSString * const VAKEmailAuthor = @"lich-se@rambler.ru";

@interface VAKSendEmailViewController () <UITextFieldDelegate, UITextViewDelegate, VAKSKPSMTPMessageServiceDelegate>

@property (weak, nonatomic) IBOutlet UITextField *senderTextField;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet UITextField *recipientTextField;
@property (weak, nonatomic) IBOutlet UITextView *bodyMessageTextView;
@property (weak, nonatomic) IBOutlet UIStackView *recipientStackView;

@property (strong, nonatomic) NSMutableArray *recipients;

@end

@implementation VAKSendEmailViewController

#pragma mark - Implementation protocol VAKSKPSMTPMessageServiceDelegate

- (void)confirmOfSendingMessage:(NSError *)error {
    if (!self.presentedViewController) {
        NSString *title;
        NSString *message;
        if (error) {
            title = @"Message not sent!";
            message = [NSString stringWithFormat:@"Error %@", error];
        }
        else {
            title = @"Message sent!";
            message = @"Success!";
        }
        [self presentViewController:[UIAlertController alertControllerWithTitle:title message:message handler:nil] animated:YES completion:nil];
    }
}

#pragma mark - Lazy getters

- (NSMutableArray *)recipients {
    if (!_recipients) {
        _recipients = [NSMutableArray array];
    }
    return _recipients;
}

#pragma mark - Life cycle viev controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bodyMessageTextView.delegate = self;
    self.senderTextField.delegate = self;
    self.subjectTextField.delegate = self;
    self.recipientTextField.delegate = self;
    
    self.title = @"Рассказать друзьям";
    
    if (!self.recipient) {
        self.recipientStackView.hidden = YES;
        self.title = @"Обратная связь";
    }
}

#pragma mark - Actions

- (IBAction)sendEmail:(UIButton *)sender {
    if (self.senderTextField.text.isValidEmail) {
        [VAKSKPSMTPMessageService sharedSKPSMTPMessageService].delegate = self;
        if (self.isRecipient) {
            for (NSString *recipient in self.recipients) {
                [[VAKSKPSMTPMessageService sharedSKPSMTPMessageService] sendMessage:self.bodyMessageTextView.text toEmail:recipient subject:self.subjectTextField.text info:@{ VAKFromEmailInfo : self.senderTextField.text }];
            }
        }
        else {
            [[VAKSKPSMTPMessageService sharedSKPSMTPMessageService] sendMessage:self.bodyMessageTextView.text toEmail:VAKEmailAuthor subject:self.subjectTextField.text info:@{ VAKFromEmailInfo : self.senderTextField.text }];
        }
    }
    else {
        [self presentViewController:[UIAlertController alertControllerWithTitle:@"Error: invalid email" message:@"Input correct email" handler:nil] animated:YES completion:nil];
    }
}

- (IBAction)addRecipient:(UIButton *)sender {
    if (self.recipientTextField.text.isValidEmail) {
        [self.recipients addObject:self.recipientTextField.text];
        self.recipientTextField.text = nil;
    }
    else {
        [self presentViewController:[UIAlertController alertControllerWithTitle:@"Error: invalid email" message:@"Input correct email" handler:nil] animated:YES completion:nil];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.senderTextField.isFirstResponder && !self.recipientStackView.hidden) {
        [self.recipientTextField becomeFirstResponder];
    }
    else if (self.senderTextField.isFirstResponder && self.recipientStackView.hidden) {
        [self.subjectTextField becomeFirstResponder];
    }
    else if (self.recipientTextField.isFirstResponder) {
        [self.subjectTextField becomeFirstResponder];
    }
    else if (self.subjectTextField.isFirstResponder) {
        [self.bodyMessageTextView becomeFirstResponder];
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    if (self.senderTextField.isFirstResponder) {
        [self.senderTextField resignFirstResponder];
    }
    else if (self.recipientTextField.isFirstResponder) {
        [self.recipientTextField resignFirstResponder];
    }
    else if (self.subjectTextField.isFirstResponder) {
        [self.subjectTextField resignFirstResponder];
    }
    else if (self.bodyMessageTextView.isFirstResponder) {
        [self.bodyMessageTextView resignFirstResponder];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
