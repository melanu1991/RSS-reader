#import <UIKit/UIKit.h>

@protocol VAKSlideMenuDelegate;

static NSString * const VAKSlideMenuViewControllerIdentifier = @"VAKSlideMenuViewController";
static NSString * const VAKUpdateDataNotification = @"VAKUpdateDataNotification";

@interface VAKSlideMenuViewController : UIViewController

@property (weak, nonatomic) id<VAKSlideMenuDelegate> delegate;
@property (assign, nonatomic) BOOL isSlideMenu;

+ (instancetype)sharedSlideMenu;

- (void)showMenu;
- (void)hideMenu;

@end
