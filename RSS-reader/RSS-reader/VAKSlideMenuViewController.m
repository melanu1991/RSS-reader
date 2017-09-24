#import "VAKSlideMenuViewController.h"
#import "VAKAboutUsViewController.h"
#import "VAKUIAlertController+Message.h"
#import "VAKNetManager.h"
#import "VAKNewsParser.h"
#import "VAKNewsURL.h"

static NSString * const VAKAboutViewControllerIdentifier = @"VAKAboutUsViewController";

@interface VAKSlideMenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *slideMenuView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation VAKSlideMenuViewController

#pragma mark - Shared Singleton

+ (instancetype)sharedSlideMenu {
    static VAKSlideMenuViewController *slideMenuVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        slideMenuVC = [storyboard instantiateViewControllerWithIdentifier:VAKSlideMenuViewControllerIdentifier];
    });
    return slideMenuVC;
}

#pragma mark - life cycle view controller

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - actions

- (IBAction)menuButtonPressed:(UIButton *)sender {
    [self hideMenu];
    switch (sender.tag) {
        case 0:
        case 1:
        case 2:
            [self loadDataWithTag:sender.tag];
            break;
        default:
            break;
    }
}

#pragma mark - helpers

- (void)loadDataWithTag:(NSInteger)tag {
    NSString *path = VAKNewsURL[tag];
    NSDictionary *info = @{ @"url" : path };
    [[VAKNetManager sharedManager] loadDataWithPath:path completionHandler:^(NSArray *data, NSError *error) {
        if (!error) {
            [VAKNewsParser newsWithData:data urlIdentifier:tag];
            [[NSNotificationCenter defaultCenter] postNotificationName:VAKUpdateDataNotification object:nil userInfo:info];
        }
        else {
            [self.view.window.rootViewController presentViewController:[UIAlertController alertControllerWithTitle:@"Error load data" message:@"No connection to the server" handler:nil] animated:YES completion:nil];
        }
    }];
}

#pragma mark - custom touch handling

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideMenu];
}

#pragma mark - work with slide menu

- (void)showMenu {
    self.view.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = CGRectMake(0.f, 0.f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [window addSubview:self.view];
        self.isSlideMenu = YES;
    }];
}

- (void)hideMenu {
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, 0.f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        self.isSlideMenu = NO;
    }];
}

@end
