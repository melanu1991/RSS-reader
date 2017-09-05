#import "VAKMainScreenViewController.h"
#import "VAKSlideMenuViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString * const VAKSlideMenuViewControllerIdentifier = @"VAKSlideMenuViewController";

@interface VAKMainScreenViewController ()

@property (strong, nonatomic) VAKSlideMenuViewController *slideMenuVC;

@end

@implementation VAKMainScreenViewController

#pragma mark - life cycle view controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.slideMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:VAKSlideMenuViewControllerIdentifier];
}

#pragma mark - actions

- (IBAction)slideMenuButtonPressed:(UIBarButtonItem *)sender {
    
    if (!self.slideMenuVC.isSlideMenu) {
        [self.slideMenuVC showMenu];
    }
    else {
        [self.slideMenuVC hideMenu];
    }
    
}

@end
