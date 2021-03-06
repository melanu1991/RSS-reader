#import "VAKSlideMenuViewController.h"
#import "VAKUIAlertController+Message.h"
#import "VAKNetManager.h"
#import "VAKNewsParser.h"
#import "VAKConstantsNewsURL.h"
#import "VAKSlideMenuDelegate.h"
#import "VAKMainScreenViewController.h"

static NSString * const VAKStoryboardIdentifier = @"Main";

@interface VAKSlideMenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *slideMenuView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *collectionIndicators;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *collectionCircles;

@property (assign, nonatomic) NSInteger selectedButtonTag;

@end

@implementation VAKSlideMenuViewController

#pragma mark - UIStoryboardSegue

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([self.delegate isMemberOfClass:[VAKMainScreenViewController class]] && [identifier isEqualToString:VAKMainScreenStoryboardSegue]) {
        return NO;
    }
    return YES;
}

#pragma mark - Shared Singleton

+ (instancetype)sharedSlideMenu {
    static VAKSlideMenuViewController *slideMenuVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:VAKStoryboardIdentifier bundle:nil];
        slideMenuVC = [storyboard instantiateViewControllerWithIdentifier:VAKSlideMenuViewControllerIdentifier];
        slideMenuVC.selectedButtonTag = -1;
    });
    return slideMenuVC;
}

#pragma mark - actions

- (IBAction)menuButtonPressed:(UIButton *)sender {
    
    if (self.selectedButtonTag != sender.tag) {
        [self clearGradient];
        self.selectedButtonTag = sender.tag;
        [self addGradientForButtonTag:sender.tag];
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
    [self hideMenu];
}

#pragma mark - helpers

- (void)addGradientForButtonTag:(NSInteger)tag {
    NSInteger startIndex = tag;
    NSInteger endIndex = startIndex + 1;
    for (NSInteger i = startIndex; i <= endIndex; i ++) {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        UIView *view = self.collectionIndicators[i];
        gradientLayer.frame = view.bounds;
        [view.layer addSublayer:gradientLayer];
        gradientLayer.colors = @[ (__bridge id)[UIColor colorWithRed:179.f / 255.f green:179.f / 255.f blue:179.f / 255.f alpha:1.f].CGColor, (__bridge id)[UIColor colorWithRed:179.f / 255.f green:179.f / 255.f blue:179.f / 255.f alpha:1.f].CGColor, (__bridge id)[UIColor colorWithRed:1.f green:1.f blue:1.f alpha:1.f].CGColor ];
        gradientLayer.startPoint = CGPointMake(0.f, 0.f);
        gradientLayer.endPoint = CGPointMake(1.f, 1.f);
    }
    UIView *circle = self.collectionCircles[tag];
    circle.backgroundColor = [UIColor colorWithRed:249.f / 255.f green:249.f / 255.f blue:249.f / 255.f alpha:1.f];
}

- (void)clearGradient {
    NSInteger startIndex = self.selectedButtonTag;
    if (startIndex != -1) {
        NSInteger endIndex = startIndex + 1;
        for (NSInteger i = startIndex; i <= endIndex; i ++) {
            UIView *view = self.collectionIndicators[i];
            for (CALayer *layer in view.layer.sublayers) {
                if ([layer isKindOfClass:[CAGradientLayer class]]) {
                    [layer removeFromSuperlayer];
                }
            }
        }
        UIView *circle = self.collectionCircles[self.selectedButtonTag];
        circle.backgroundColor = [UIColor colorWithRed:179.f / 255.f green:179.f / 255.f blue:179.f / 255.f alpha:1.f];
    }
}

- (void)loadDataWithTag:(NSInteger)tag {
    NSString *path = VAKNewsURL[tag];
    NSDictionary *info = @{ VAKUpdateDataNotificationKey : path };
    [[VAKNetManager sharedManager] loadDataWithPath:path completionBlock:^(NSArray *data, NSError *error) {
        if (!error) {
            [VAKNewsParser newsWithData:data identifierUrlChannel:tag completionBlock:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:VAKUpdateDataNotification object:nil userInfo:info];
            }];
        }
        else {
            [self.view.window.rootViewController presentViewController:[UIAlertController alertControllerWithTitle:@"Error load data" message:@"No connection to the server. Data will be downloaded from the database." handler:^(UIAlertAction * _Nonnull action) {
                [[NSNotificationCenter defaultCenter] postNotificationName:VAKUpdateDataNotification object:nil userInfo:info];
            }] animated:YES completion:nil];
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
    [UIView animateWithDuration:0.25f animations:^{
        self.view.frame = CGRectMake(0.f, 0.f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [window addSubview:self.view];
        self.isSlideMenu = YES;
    }];
}

- (void)hideMenu {
    [UIView animateWithDuration:0.25f animations:^{
        self.view.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, 0.f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self.delegate animateHideSlideMenu];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        self.isSlideMenu = NO;
    }];
}

@end
