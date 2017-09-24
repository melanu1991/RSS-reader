#import "VAKAboutUsViewController.h"
#import "VAKSlideMenuViewController.h"
#import "VAKWebViewController.h"
#import "VAKSendEmailViewController.h"
#import "VAKSlideMenuDelegate.h"
#import "VAKSlideMenuViewController.h"

@interface VAKAboutUsViewController () <VAKSlideMenuDelegate>

@end

@implementation VAKAboutUsViewController

#pragma mark - VAKSlideMenuDelegate

- (void)animateHideSlideMenu {
    self.view.frame = CGRectMake(0.f, self.view.frame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    self.navigationController.navigationBar.frame = CGRectMake(0.f, self.navigationController.navigationBar.frame.origin.y, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height);
}

#pragma mark - Actions

- (IBAction)slideMenuButtonPressed:(UIBarButtonItem *)sender {
    [[VAKSlideMenuViewController sharedSlideMenu] showMenu];
    [VAKSlideMenuViewController sharedSlideMenu].delegate = self;
    [UIView animateWithDuration:0.25f animations:^{
        self.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.f, self.view.frame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
        self.navigationController.navigationBar.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.f, self.navigationController.navigationBar.frame.origin.y, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height);
    }];
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
            webVC.link = @"https://itunes.apple.com/ru/app/newsify-your-news-blog-rss-feed-reader/id510153374?mt=8";
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
