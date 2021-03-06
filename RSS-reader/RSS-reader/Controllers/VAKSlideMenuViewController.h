#import <UIKit/UIKit.h>

@protocol VAKSlideMenuDelegate;

static NSString * const VAKSlideMenuViewControllerIdentifier = @"VAKSlideMenuViewController";
static NSString * const VAKMainScreenStoryboardSegue = @"VAKMainScreenStoryboardSegue";
static NSString * const VAKUpdateDataNotification = @"VAKUpdateDataNotification";
static NSString * const VAKUpdateDataNotificationKey = @"url";

@interface VAKSlideMenuViewController : UIViewController

@property (weak, nonatomic) id<VAKSlideMenuDelegate> delegate;
@property (assign, nonatomic) BOOL isSlideMenu;

+ (instancetype)sharedSlideMenu;

- (void)showMenu;
- (void)hideMenu;

@end
