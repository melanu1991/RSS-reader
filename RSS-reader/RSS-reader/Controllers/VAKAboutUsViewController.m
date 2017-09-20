#import "VAKAboutUsViewController.h"
#import "VAKSlideMenuViewController.h"

@interface VAKAboutUsViewController ()

@property (strong, nonatomic) VAKSlideMenuViewController *slideMenuVC;

@end

@implementation VAKAboutUsViewController

#pragma mark - lazy getters

- (VAKSlideMenuViewController *)slideMenuVC {
    if (!_slideMenuVC) {
        _slideMenuVC = [[VAKSlideMenuViewController alloc] init];
    }
    return _slideMenuVC;
}

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
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
}

@end
