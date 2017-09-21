#import "VAKFeedbackViewController.h"
#import "VAKNSString+ValidateEmail.h"

@interface VAKFeedbackViewController ()

@property (weak, nonatomic) IBOutlet UITextView *bodyMessageTextView;
@property (weak, nonatomic) IBOutlet UITextField *senderEmailTextField;

@end

@implementation VAKFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (IBAction)sendEmail:(UIButton *)sender {
    NSLog(@"%d", self.senderEmailTextField.text.isValidEmail);
}

@end
