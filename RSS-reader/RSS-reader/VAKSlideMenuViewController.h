#import <UIKit/UIKit.h>

static NSString * const VAKSlideMenuViewControllerIdentifier = @"VAKSlideMenuViewController";
static NSString * const VAKUpdateDataNotification = @"VAKUpdateDataNotification";

@interface VAKSlideMenuViewController : UIViewController

@property (assign, nonatomic) BOOL isSlideMenu;

+ (instancetype)sharedSlideMenu;

- (void)showMenu;
- (void)hideMenu;

@end
