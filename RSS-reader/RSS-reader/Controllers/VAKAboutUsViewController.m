#import "VAKAboutUsViewController.h"
#import "VAKSlideMenuViewController.h"
#import "VAKWebViewController.h"
#import "VAKSendEmailViewController.h"

@interface VAKAboutUsViewController ()

@end

@implementation VAKAboutUsViewController

#pragma mark - lazy getters


#pragma mark - lifecycle view controller

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)slideMenuButtonPressed:(UIBarButtonItem *)sender {
    
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
            VAKWebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:VAKWebViewControllerIdentifier];
            webVC.link = @"https://itunes.apple.com/by/app/shrook-rss-reader/id411227658";
            [self.navigationController pushViewController:webVC animated:YES];
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
