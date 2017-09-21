#import "VAKUIAlertController+Message.h"

@implementation UIAlertController (Message)

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message handler:(void(^)(UIAlertAction * _Nonnull action))handler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:handler];
    [alertController addAction:action];
    return alertController;
}

@end
