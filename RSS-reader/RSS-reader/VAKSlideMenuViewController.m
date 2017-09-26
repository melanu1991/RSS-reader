#import "VAKSlideMenuViewController.h"
#import "VAKUIAlertController+Message.h"
#import "VAKNetManager.h"
#import "VAKNewsParser.h"
#import "VAKNewsURL.h"
#import "VAKSlideMenuDelegate.h"
#import "VAKMainScreenViewController.h"

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
    if ([self.delegate isMemberOfClass:[VAKMainScreenViewController class]] && [identifier isEqualToString:@"VAKMainScreenStoryboardSegue"]) {
        return NO;
    }
    return YES;
}

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

#pragma mark - actions

- (IBAction)menuButtonPressed:(UIButton *)sender {
    
    [self clearGradient];
    self.selectedButtonTag = sender.tag;
    [self addGradientForButtonTag:sender.tag];
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
