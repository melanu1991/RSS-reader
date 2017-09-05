#import "VAKMainScreenViewController.h"
#import "VAKSlideMenuViewController.h"

static NSString * const VAKSlideMenuViewControllerIdentifier = @"VAKSlideMenuViewController";

@interface VAKMainScreenViewController ()

@property (strong, nonatomic) VAKSlideMenuViewController *slideMenuVC;

@end

@implementation VAKMainScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.slideMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:VAKSlideMenuViewControllerIdentifier];
}

- (IBAction)slideMenuButtonPressed:(UIBarButtonItem *)sender {
    
    if (!self.slideMenuVC.isSlideMenu) {
        [self.slideMenuVC showMenu];
    }
    else {
        [self.slideMenuVC hideMenu];
    }
    
}

@end
