#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIAlertController (Message)

+ (instancetype _Nonnull )alertControllerWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message handler:(void(^_Nullable)(UIAlertAction * _Nonnull action))handler;

@end
