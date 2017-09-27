#import "VAKUIView+AnimationViews.h"

@implementation UIView (VAKAnimationViews)

+ (void)animateWithDuration:(NSTimeInterval)duration coordinateX:(CGFloat)coordinateX views:(NSArray *)views {
    [UIView animateWithDuration:duration animations:^{
        for (UIView *view in views) {
            view.frame = CGRectMake(coordinateX, view.frame.origin.y, view.bounds.size.width, view.bounds.size.height);
        }
    }];
}

@end
