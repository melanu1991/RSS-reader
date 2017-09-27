#import <UIKit/UIKit.h>

@interface VAKNewsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newsImageViewHeight;

@end
