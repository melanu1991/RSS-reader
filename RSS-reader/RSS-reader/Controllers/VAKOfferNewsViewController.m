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

@interface VAKOfferNewsViewController () <VAKSlideMenuDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, VAKSKPSMTPMessageServiceDelegate, UITextFieldDelegate>

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

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.phoneNumberTextField] && ![textField.text containsString:@"+375("]) {
        textField.text = [textField.text stringByAppendingString:@"+375("];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.phoneNumberTextField] && string.integerValue && textField.text.length < 17) {
        if (range.location == 0 && ![textField.text containsString:@"+375("]) {
            textField.text = [textField.text stringByAppendingString:@"+375("];
        }
        if (range.location == 6 && ![textField.text containsString:@")"]) {
            textField.text = [textField.text stringByAppendingString:[NSString stringWithFormat:@"%@)", string]];
            return NO;
        }
        else if ( range.location == 10 || range.location == 13 ) {
            textField.text = [textField.text stringByAppendingString:[NSString stringWithFormat:@"%@-", string]];
            return NO;
        }
        return YES;
    }
    else if (![textField isEqual:self.phoneNumberTextField]) {
        return YES;
    }
    else if ( [textField isEqual:self.messageOfNewsTextField] && textField.text.length > 5000) {
        return NO;
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.messageOfNewsTextField.isFirstResponder) {
        [self.phoneNumberTextField becomeFirstResponder];
    }
    else if (self.phoneNumberTextField.isFirstResponder) {
        [self.emailTextField becomeFirstResponder];
    }
    else if (self.emailTextField.isFirstResponder) {
        [self.emailTextField resignFirstResponder];
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    if (self.messageOfNewsTextField.isFirstResponder) {
        [self.messageOfNewsTextField resignFirstResponder];
    }
    else if (self.phoneNumberTextField.isFirstResponder) {
        [self.phoneNumberTextField resignFirstResponder];
    }
    else if (self.emailTextField.isFirstResponder) {
        [self.emailTextField resignFirstResponder];
    }
}

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
    if (self.emailTextField.text.isValidEmail || self.phoneNumberTextField.text.isValidPhoneNumber) {
        NSDictionary *info = @{ VAKImagesInfo : self.images, VAKFilesInfo : self.files, VAKPhoneNumberInfo : self.phoneNumberTextField.text, VAKFromEmailInfo : self.emailTextField.text };
        [VAKSKPSMTPMessageService sharedSKPSMTPMessageService].delegate = self;
        [[VAKSKPSMTPMessageService sharedSKPSMTPMessageService] sendMessage:self.messageOfNewsTextField.text toEmail:VAKEmailsChannels[self.segmentedControl.selectedSegmentIndex] subject:@"Offers news" info:info];
    }
    else {
        [self presentViewController:[UIAlertController alertControllerWithTitle:@"Error: invalid email or phone number" message:@"You must input correct email or phone number" handler:nil] animated:YES completion:nil];
    }
}

@end
