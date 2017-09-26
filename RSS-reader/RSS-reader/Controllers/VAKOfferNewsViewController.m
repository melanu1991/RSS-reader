#import "VAKOfferNewsViewController.h"
#import "VAKConstantsEmailsChannels.h"
#import "VAKSKPSMTPMessageService.h"
#import "VAKNSString+ValidateEmail.h"
#import "VAKNSString+ValidatePhoneNumber.h"
#import "VAKUIAlertController+Message.h"
#import "VAKSlideMenuViewController.h"
#import "VAKSlideMenuDelegate.h"

@interface VAKOfferNewsViewController () <VAKSlideMenuDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *messageOfNewsTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIView *offersNewsView;

@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableArray *files;

@end

@implementation VAKOfferNewsViewController

#pragma mark - Lazy getters

- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (NSMutableArray *)files {
    if (!_files) {
        _files = [NSMutableArray array];
    }
    return _files;
}

#pragma mark - VAKSlideMenuDelegate

- (void)animateHideSlideMenu {
    [UIView animateWithDuration:0.25f animations:^{
        self.navigationController.navigationBar.frame = CGRectMake(0.f, self.navigationController.navigationBar.frame.origin.y, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height);
        self.offersNewsView.frame = CGRectMake(0.f, self.offersNewsView.frame.origin.y, self.offersNewsView.bounds.size.width, self.offersNewsView.bounds.size.height);
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self.images addObject:info[UIImagePickerControllerOriginalImage]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - actions

- (IBAction)slideMenuButtonPressed:(UIBarButtonItem *)sender {
    [[VAKSlideMenuViewController sharedSlideMenu] showMenu];
    [VAKSlideMenuViewController sharedSlideMenu].delegate = self;
    [UIView animateWithDuration:0.25f animations:^{
        self.navigationController.navigationBar.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.f, self.navigationController.navigationBar.frame.origin.y, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height);
        self.offersNewsView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.f, self.offersNewsView.frame.origin.y, self.offersNewsView.bounds.size.width, self.offersNewsView.bounds.size.height);
    }];
}

- (IBAction)selectPhotosButtonPressed:(UIButton *)sender {
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.delegate = self;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)selectDocumentsButtonPressed:(UIButton *)sender {
    
}

- (IBAction)sendMessageButtonPressed:(UIButton *)sender {
//    if (self.emailTextField.text.isValidEmail || self.phoneNumberTextField.text.isValidPhoneNumber) {
//        [[VAKSKPSMTPMessageService sharedSKPSMTPMessageService] sendMessage:self.messageOfNewsTextField.text fromEmail:self.emailTextField.text toEmail:VAKEmailsChannels[self.segmentedControl.selectedSegmentIndex] subject:@"Предложить новость"];
    NSDictionary *info = @{ VAKImagesInfo : self.images, VAKFilesInfo : self.files, VAKPhoneNumberInfo : @"+375(44)792-85-27", VAKFromEmailInfo : @"myEmail@mail.ru" };
    [[VAKSKPSMTPMessageService sharedSKPSMTPMessageService] sendMessage:@"sdfsdf" toEmail:@"lich-se@rambler.ru" subject:@"fsdfsd" info:info];
//    }
//    else {
//        [self presentViewController:[UIAlertController alertControllerWithTitle:@"Error: invalid email or phone number" message:@"You must input correct email or phone number" handler:nil] animated:YES completion:nil];
//    }
}

@end
