#import "VAKUIView+AnimationViews.h"

@implementation UIView (VAKAnimationViews)

+ (void)animateWithDuration:(NSTimeInterval)duration views:(NSArray *)views {
    [UIView animateWithDuration:duration animations:^{
        for (UIView *view in views) {
            view.frame = CGRectMake(0.f, view.frame.origin.y, view.bounds.size.width, view.bounds.size.height);
        }
    }];
}

@end
