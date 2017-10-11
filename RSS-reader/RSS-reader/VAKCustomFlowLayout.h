#import <UIKit/UIKit.h>

@protocol VAKCustomLayoutDelegate <UICollectionViewDelegateFlowLayout>

@optional

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section;

@end

@interface VAKCustomFlowLayout: UICollectionViewFlowLayout

@property (nonatomic, weak) id<VAKCustomLayoutDelegate> delegate;
@property (nonatomic, assign) CGFloat singleCellWidth;
@property (nonatomic, assign) CGFloat columnCount;
@property (nonatomic, assign) CGFloat contentHeight;

@end
