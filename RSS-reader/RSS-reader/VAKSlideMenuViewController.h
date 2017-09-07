#import <UIKit/UIKit.h>

static NSString * const VAKUpdateDataNotification = @"VAKUpdateDataNotification";

@interface VAKSlideMenuViewController : UIViewController

@property (assign, nonatomic) BOOL isSlideMenu;

- (void)showMenu;
- (void)hideMenu;

@end
