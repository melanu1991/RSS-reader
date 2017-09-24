#import "VAKOfferNewsViewController.h"
#import "VAKConstantsEmailsChannels.h"
#import "VAKSKPSMTPMessageService.h"
#import "VAKNSString+ValidateEmail.h"
#import "VAKNSString+ValidatePhoneNumber.h"
#import "VAKUIAlertController+Message.h"
#import "VAKSlideMenuViewController.h"
#import "VAKSlideMenuDelegate.h"

@interface VAKOfferNewsViewController () <VAKSlideMenuDelegate>

@property (weak, nonatomic) IBOutlet UITextField *messageOfNewsTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableArray *files;

@end

@implementation VAKOfferNewsViewController

#pragma mark - VAKSlideMenuDelegate

- (void)animateHideSlideMenu {
    self.navigationController.navigationBar.frame = CGRectMake(0.f, self.navigationController.navigationBar.frame.origin.y, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height);
    self.view.frame = CGRectMake(0.f, self.view.frame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
}

#pragma mark - life cycle view controller

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - actions

- (IBAction)slideMenuButtonPressed:(UIBarButtonItem *)sender {
    [[VAKSlideMenuViewController sharedSlideMenu] showMenu];
    [VAKSlideMenuViewController sharedSlideMenu].delegate = self;
    [UIView animateWithDuration:0.25f animations:^{
        self.navigationController.navigationBar.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.f, self.navigationController.navigationBar.frame.origin.y, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height);
        self.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.f, self.view.frame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    }];
}

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
