#import <UIKit/UIKit.h>

static NSString * const VAKSendEmailViewControllerIdentifier = @"VAKSendEmailViewController";

@interface VAKSendEmailViewController : UIViewController

@property (assign, nonatomic, getter = isRecipient) BOOL recipient;

@end
