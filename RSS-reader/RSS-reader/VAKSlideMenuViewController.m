#import "VAKSlideMenuViewController.h"
#import "VAKNetManager.h"
#import "VAKNewsParser.h"
#import "VAKNewsURL.h"

@interface VAKSlideMenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *slideMenuView;

@end

@implementation VAKSlideMenuViewController

#pragma mark - life cycle view controller

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - actions

- (IBAction)menuButtonPressed:(UIButton *)sender {
    [self hideMenu];
    NSString *path = VAKNewsURL[sender.tag];
    NSDictionary *info = @{ @"url" : path };
    [[VAKNetManager sharedManager] loadDataWithPath:path completionHandler:^(NSArray *data, NSError *error) {
        if (!error) {
            [VAKNewsParser newsWithData:data urlIdentifier:sender.tag];
            [[NSNotificationCenter defaultCenter] postNotificationName:VAKUpdateDataNotification object:nil userInfo:info];
        }
        else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error load data" message:@"Server connection failed" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[NSNotificationCenter defaultCenter] postNotificationName:VAKUpdateDataNotification object:nil userInfo:info];
            }];
            [alert addAction:action];
            [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
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
