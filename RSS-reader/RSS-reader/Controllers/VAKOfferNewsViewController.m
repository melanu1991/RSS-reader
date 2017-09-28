#import "VAKOfferNewsViewController.h"
#import "VAKConstantsEmailsChannels.h"
#import "VAKSKPSMTPMessageService.h"
#import "VAKNSString+ValidateEmail.h"
#import "VAKNSString+ValidatePhoneNumber.h"
#import "VAKUIAlertController+Message.h"
#import "VAKSlideMenuViewController.h"
#import "VAKSlideMenuDelegate.h"
#import "VAKUIView+AnimationViews.h"
#import "VAKSKPSMTPMessageServiceDelegate.h"

@interface VAKOfferNewsViewController () <VAKSlideMenuDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, VAKSKPSMTPMessageServiceDelegate>

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

#pragma mark - Implementation protocol VAKSKPSMTPMessageServiceDelegate

- (void)confirmOfSendingMessage:(NSError *)error {
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
    [self presentViewController:[UIAlertController alertControllerWithTitle:title message:message handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }] animated:YES completion:nil];
}

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
    [UIView animateWithDuration:0.25f coordinateX:0.f views:@[self.navigationController.navigationBar, self.offersNewsView]];
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
    [UIView animateWithDuration:0.25f coordinateX:[UIScreen mainScreen].bounds.size.width / 2.f views:@[self.navigationController.navigationBar, self.offersNewsView]];
}

- (IBAction)selectPhotosButtonPressed:(UIButton *)sender {
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.delegate = self;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)selectDocumentsButtonPressed:(UIButton *)sender {
    
}

- (IBAction)sendMessageButtonPressed:(UIButton *)sender {
    NSDictionary *info = @{ VAKImagesInfo : self.images, VAKFilesInfo : self.files, VAKPhoneNumberInfo : self.phoneNumberTextField.text, VAKFromEmailInfo : self.emailTextField.text };
    if (self.emailTextField.text.isValidEmail || self.phoneNumberTextField.text.isValidPhoneNumber) {
        [VAKSKPSMTPMessageService sharedSKPSMTPMessageService].delegate = self;
        [[VAKSKPSMTPMessageService sharedSKPSMTPMessageService] sendMessage:self.messageOfNewsTextField.text toEmail:VAKEmailsChannels[self.segmentedControl.selectedSegmentIndex] subject:@"Предложить новость" info:info];
    }
    else {
        [self presentViewController:[UIAlertController alertControllerWithTitle:@"Error: invalid email or phone number" message:@"You must input correct email or phone number" handler:nil] animated:YES completion:nil];
    }
}

@end
