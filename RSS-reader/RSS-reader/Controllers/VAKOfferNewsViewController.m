#import "VAKOfferNewsViewController.h"
#import "VAKConstantsEmailsChannels.h"
#import "VAKSKPSMTPMessageService.h"
#import "VAKNSString+ValidateEmail.h"
#import "VAKNSString+ValidatePhoneNumber.h"
#import "VAKUIAlertController+Message.h"
#import "VAKSlideMenuViewController.h"

@interface VAKOfferNewsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *messageOfNewsTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableArray *files;

@end

@implementation VAKOfferNewsViewController

#pragma mark - life cycle view controller

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - actions

- (IBAction)selectPhotosButtonPressed:(UIButton *)sender {
    
}

- (IBAction)selectDocumentsButtonPressed:(UIButton *)sender {
    
}

- (IBAction)sendMessageButtonPressed:(UIButton *)sender {
    if (self.emailTextField.text.isValidEmail || self.phoneNumberTextField.text.isValidPhoneNumber) {
        [[VAKSKPSMTPMessageService sharedSKPSMTPMessageService] sendMessage:self.messageOfNewsTextField.text fromEmail:self.emailTextField.text toEmail:VAKEmailsChannels[self.segmentedControl.selectedSegmentIndex] subject:@"Предложить новость"];
    }
    else {
        [self presentViewController:[UIAlertController alertControllerWithTitle:@"Error: invalid email or phone number" message:@"You must input correct email or phone number" handler:nil] animated:YES completion:nil];
    }
}

@end
