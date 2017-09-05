#import "VAKSlideMenuViewController.h"

@interface VAKSlideMenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *slideMenuView;

@end

@implementation VAKSlideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)menuButtonPressed:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            NSLog(@"%ld", sender.tag);
            break;
        case 1:
            NSLog(@"%ld", sender.tag);
            break;
        case 2:
            NSLog(@"%ld", sender.tag);
            break;
        default:
            NSLog(@"%@", @"default");
            break;
    }
}

@end
