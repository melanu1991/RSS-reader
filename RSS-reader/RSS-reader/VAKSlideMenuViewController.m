#import "VAKSlideMenuViewController.h"
#import "VAKNetManager.h"
#import "VAKNewsParser.h"

typedef NS_ENUM(NSUInteger, URLNews) {
    URLNewsTutBy,
    URLNewsOnlinerBy,
    URLNewsLentaRu
};

static NSString * const VAKArrayNews[] = {
    [URLNewsTutBy] = @"https://news.tut.by/rss",
    [URLNewsOnlinerBy] = @"https:www.onliner.by/feed",
    [URLNewsLentaRu] = @"https://lenta.ru/rss"
};

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
    NSString *path = VAKArrayNews[sender.tag];
    [[VAKNetManager sharedManager] loadDataWithPath:path completionHandler:^(NSArray *data, NSError *error) {
        if (!error) {
            [VAKNewsParser newsWithData:data urlIdentifier:sender.tag];
            [[NSNotificationCenter defaultCenter] postNotificationName:VAKUpdateDataNotification object:nil];
        }
        else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error load data" message:@"Server connection failed" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
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
    [UIView animateWithDuration:1.f animations:^{
        self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [window addSubview:self.view];
        self.isSlideMenu = YES;
    }];
}

- (void)hideMenu {
    [UIView animateWithDuration:1.f animations:^{
        self.view.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        self.isSlideMenu = NO;
    }];
}

@end
