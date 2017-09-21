#import "VAKFeedbackViewController.h"
#import "VAKNSString+ValidateEmail.h"
#import "VAKSKPSMTPMessageService.h"
#import "VAKUIAlertController+Message.h"

@interface VAKFeedbackViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *bodyMessageTextView;
@property (weak, nonatomic) IBOutlet UITextField *senderEmailTextField;

@end

@implementation VAKFeedbackViewController

#pragma mark - Lifecycle view controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bodyMessageTextView.delegate = self;
    self.senderEmailTextField.delegate = self;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.bodyMessageTextView becomeFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    if (self.bodyMessageTextView.isFirstResponder) {
        [self.bodyMessageTextView resignFirstResponder];
    }
    else if (self.senderEmailTextField.isFirstResponder) {
        [self.senderEmailTextField resignFirstResponder];
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

#pragma mark - Actions

- (IBAction)sendEmail:(UIButton *)sender {
    if (self.senderEmailTextField.text.isValidEmail) {
        [[VAKSKPSMTPMessageService sharedSKPSMTPMessageService] sendMessage:self.bodyMessageTextView.text fromEmail:self.senderEmailTextField.text toEmail:@"lich-se@rambler.ru" subject:@"Feedback Rss reader"];
    }
    else {
        [self presentViewController:[UIAlertController alertControllerWithTitle:@"Error: invalid email" message:@"Input correct email" handler:nil] animated:YES completion:nil];
    }
}

@end
