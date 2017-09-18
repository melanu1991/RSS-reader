#import "VAKMainScreenViewController.h"
#import "VAKSlideMenuViewController.h"
#import "VAKDataManager.h"
#import "News+CoreDataClass.h"
#import "Category+CoreDataClass.h"
#import "VAKWebViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import "VAKNewsCollectionViewCell.h"

static NSString * const VAKSlideMenuViewControllerIdentifier = @"VAKSlideMenuViewController";
static NSString * const VAKWebViewControllerIdentifier = @"VAKWebViewController";
static NSString * const VAKCellReuseIdentifier = @"newsCell";
static NSString * const VAKSortDescriptorKey = @"pubDate";
static NSString * const VAKPlaceholder = @"placeholder";

@interface VAKMainScreenViewController ()

@property (strong, nonatomic) VAKSlideMenuViewController *slideMenuVC;
@property (strong, nonatomic) NSArray *news;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign, nonatomic) NSInteger columnCount;
@property (assign, nonatomic) NSInteger miniInteriorSpacing;

@end

@implementation VAKMainScreenViewController

#pragma mark - lazy getters

- (VAKSlideMenuViewController *)slideMenuVC {
    if (!_slideMenuVC) {
        _slideMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:VAKSlideMenuViewControllerIdentifier];
    }
    return _slideMenuVC;
}

#pragma mark - life cycle view controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.columnCount = 2;
    self.miniInteriorSpacing = 10;
    
    if(![self.collectionView.collectionViewLayout isKindOfClass:[VAKCustomFlowLayout class]]){
        VAKCustomFlowLayout *layout = [VAKCustomFlowLayout new];
        layout.delegate = self;
        layout.columnCount = self.columnCount;
        
        self.collectionView.collectionViewLayout = layout;
        
        [self.collectionView reloadData];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData:) name:VAKUpdateDataNotification object:nil];
}

#pragma mark - notification method

- (void)updateData:(NSNotification *)notification {
    self.news = [VAKDataManager allEntitiesWithName:VAKNewsEntityName predicate:[NSPredicate predicateWithFormat:@"category.channel.url == %@", notification.userInfo[@"url"]] sortDescriptor:[NSSortDescriptor sortDescriptorWithKey:VAKSortDescriptorKey ascending:YES]];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.news.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VAKNewsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VAKCellReuseIdentifier forIndexPath:indexPath];
    News *news = self.news[indexPath.row];
    cell.newsTitle.text = news.title;
    [cell.newsImageView sd_setShowActivityIndicatorView:YES];
    [cell.newsImageView sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [cell.newsImageView sd_setImageWithURL:[NSURL URLWithString:news.imageURL] placeholderImage:[UIImage imageNamed:VAKPlaceholder]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    VAKWebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:VAKWebViewControllerIdentifier];
    News *news = self.news[indexPath.row];
    webVC.link = news.link;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    News *news = [self.news objectAtIndex:indexPath.row];
    CGFloat labelSize = [self calculateHeightForLabel:news.title width:self.view.frame.size.width / 2 - 20];
    return CGSizeMake(self.view.frame.size.width / 2 - 20, labelSize + 30 + 120);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

#pragma mark - helpers

-(float)calculateHeightForLabel:(NSString*)text width:(float)width {
    CGSize constraint = CGSizeMake(width, 20000.f);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [text boundingRectWithSize:constraint
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                            context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height + 10;
}

#pragma mark - actions with slide menu

- (IBAction)slideMenuButtonPressed:(UIBarButtonItem *)sender {
    
    [self.slideMenuVC showMenu];
    [UIView animateWithDuration:0.5f animations:^{
        self.collectionView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.f, self.collectionView.frame.origin.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
        self.navigationController.navigationBar.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.f, self.navigationController.navigationBar.frame.origin.y, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height);
        __weak VAKMainScreenViewController *weakMainScreenVC = self;
        self.slideMenuVC.completionBlock = ^{
            weakMainScreenVC.collectionView.frame = CGRectMake(0.f, weakMainScreenVC.collectionView.frame.origin.y, weakMainScreenVC.collectionView.bounds.size.width, weakMainScreenVC.collectionView.bounds.size.height);
            weakMainScreenVC.navigationController.navigationBar.frame = CGRectMake(0.f, weakMainScreenVC.navigationController.navigationBar.frame.origin.y, weakMainScreenVC.navigationController.navigationBar.bounds.size.width, weakMainScreenVC.navigationController.navigationBar.bounds.size.height);
        };
    }];
    
}

#pragma mark - UIToolbar actions

- (IBAction)selectCategoryButtonPressed:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 0:
            [UIView animateWithDuration:0.25 animations:^{
                
            }];
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        default:
            break;
    }
}


#pragma mark - deallocate

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
