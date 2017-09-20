#import <UIKit/UIKit.h>

@protocol MyTestProtocol;

typedef void(^VAKHideMenuCompletionBlock)();

static NSString * const VAKUpdateDataNotification = @"VAKUpdateDataNotification";

@interface VAKSlideMenuViewController : UIViewController

@property (assign, nonatomic) BOOL isSlideMenu;
@property (copy, nonatomic) VAKHideMenuCompletionBlock completionBlock;
//@property (weak, nonatomic) id<MyTestProtocol> delegate;

- (void)showMenu;
- (void)hideMenu;

@end
