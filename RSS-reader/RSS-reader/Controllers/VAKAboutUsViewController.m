#import "VAKAboutUsViewController.h"
#import "VAKSlideMenuViewController.h"
#import "VAKWebViewController.h"
#import "VAKSendEmailViewController.h"
#import "VAKSlideMenuDelegate.h"
#import "VAKSlideMenuViewController.h"
#import "VAKUIView+AnimationViews.h"

@interface VAKAboutUsViewController () <VAKSlideMenuDelegate>

@property (weak, nonatomic) IBOutlet UIView *aboutUsView;

@end

@implementation VAKAboutUsViewController

#pragma mark - VAKSlideMenuDelegate

- (void)animateHideSlideMenu {
    [UIView animateWithDuration:0.25f coordinateX:0.f views:@[self.aboutUsView, self.navigationController.navigationBar]];
}

#pragma mark - Actions

- (IBAction)slideMenuButtonPressed:(UIBarButtonItem *)sender {
    [[VAKSlideMenuViewController sharedSlideMenu] showMenu];
    [VAKSlideMenuViewController sharedSlideMenu].delegate = self;
    [UIView animateWithDuration:0.25f coordinateX:[UIScreen mainScreen].bounds.size.width / 2.f views:@[self.aboutUsView, self.navigationController.navigationBar]];
}

- (IBAction)menuAboutUsButtonPressed:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
        {
            VAKSendEmailViewController *sendEmailVC = [self.storyboard instantiateViewControllerWithIdentifier:VAKSendEmailViewControllerIdentifier];
            [self.navigationController pushViewController:sendEmailVC animated:YES];
        }
            break;
        case 1:
        {
            NSString *appStoreLink = @"https://itunes.apple.com/by/app/newsify-rss-reader/id510153374?mt=8";
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appStoreLink]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreLink] options:@{} completionHandler:nil];
            }
        }
            break;
        case 2:
        {
            VAKSendEmailViewController *sendEmailVC = [self.storyboard instantiateViewControllerWithIdentifier:VAKSendEmailViewControllerIdentifier];
            sendEmailVC.recipient = YES;
            [self.navigationController pushViewController:sendEmailVC animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
