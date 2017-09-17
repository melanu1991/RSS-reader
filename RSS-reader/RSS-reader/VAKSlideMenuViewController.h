#import <UIKit/UIKit.h>

typedef void(^VAKHideMenuCompletionBlock)();

static NSString * const VAKUpdateDataNotification = @"VAKUpdateDataNotification";

@interface VAKSlideMenuViewController : UIViewController

@property (assign, nonatomic) BOOL isSlideMenu;
@property (copy, nonatomic) VAKHideMenuCompletionBlock completionBlock;

- (void)showMenu;
- (void)hideMenu;

@end
