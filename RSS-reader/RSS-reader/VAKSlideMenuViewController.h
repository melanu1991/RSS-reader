#import <UIKit/UIKit.h>

static NSString * const VAKSlideMenuViewControllerIdentifier = @"VAKSlideMenuViewController";
static NSString * const VAKUpdateDataNotification = @"VAKUpdateDataNotification";

@protocol MyTestProtocol;

typedef void(^VAKHideMenuCompletionBlock)();

@interface VAKSlideMenuViewController : UIViewController

@property (assign, nonatomic) BOOL isSlideMenu;
@property (copy, nonatomic) VAKHideMenuCompletionBlock completionBlock;
//@property (weak, nonatomic) id<MyTestProtocol> delegate;

+ (instancetype)sharedSlideMenu;

- (void)showMenu;
- (void)hideMenu;

@end
