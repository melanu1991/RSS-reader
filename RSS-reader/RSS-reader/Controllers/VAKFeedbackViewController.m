#import "VAKFeedbackViewController.h"
#import "VAKNSString+ValidateEmail.h"
#import "VAKSKPSMTPMessageService.h"

@interface VAKFeedbackViewController ()

@property (weak, nonatomic) IBOutlet UITextView *bodyMessageTextView;
@property (weak, nonatomic) IBOutlet UITextField *senderEmailTextField;

@end

@implementation VAKFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)sendEmail:(UIButton *)sender {
    if (self.senderEmailTextField.text.isValidEmail) {
        
    }
    [[VAKSKPSMTPMessageService sharedSKPSMTPMessageService] sendMessage:@"Message" fromEmail:@"lich-se@rambler.ru" toEmail:@"melanu284733@gmail.com" subject:@"Feedback RSS reader"];
}

@end
