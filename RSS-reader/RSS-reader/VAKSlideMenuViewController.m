#import "VAKSlideMenuViewController.h"
#import "VAKNetManager.h"

static NSUInteger const amount = 3;

typedef NS_ENUM(NSUInteger, URLNews) {
    URLNewsTutBy,
    URLNewsOnlinerBy,
    URLNewsLentaRu
};

static NSString * const VAKArrayNews[amount] = {
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
    switch (sender.tag) {
        case 0:
            [[VAKNetManager sharedManager] loadDataWithPath:path];
            break;
        case 1:
            [[VAKNetManager sharedManager] loadDataWithPath:path];
            break;
        case 2:
            [[VAKNetManager sharedManager] loadDataWithPath:path];
            break;
        default:
            break;
    }
}

#pragma mark - ???

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self hideMenu];
}

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
