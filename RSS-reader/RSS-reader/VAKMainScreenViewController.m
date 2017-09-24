#import "VAKMainScreenViewController.h"
#import "VAKSlideMenuViewController.h"
#import "VAKDataManager.h"
#import "News+CoreDataClass.h"
#import "Category+CoreDataClass.h"
#import "VAKWebViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import "VAKNewsCollectionViewCell.h"
#import "VAKConstantsImages.h"
#import "VAKConstantsCategories.h"
#import "VAKNewsURL.h"
#import "VAKSlideMenuDelegate.h"

static NSString * const VAKCellReuseIdentifier = @"newsCell";
static NSString * const VAKSortDescriptorKey = @"pubDate";
static NSString * const VAKPlaceholder = @"placeholder";

@interface VAKMainScreenViewController () <VAKSlideMenuDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *categoriesButtonCollection;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (strong, nonatomic) NSArray *news;
@property (assign, nonatomic) NSInteger columnCount;
@property (assign, nonatomic) NSInteger miniInteriorSpacing;
@property (assign, nonatomic) NSInteger selectedCategoryTag;
@property (strong, nonatomic) NSString *selectedNewsChannel;

@end

@implementation VAKMainScreenViewController

#pragma mark - VAKSlideMenuDelegate

- (void)animateHideSlideMenu {
    self.collectionView.frame = CGRectMake(0.f, self.collectionView.frame.origin.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    self.navigationController.navigationBar.frame = CGRectMake(0.f, self.navigationController.navigationBar.frame.origin.y, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height);
    self.toolbar.frame = CGRectMake(0.f, self.toolbar.frame.origin.y, self.toolbar.bounds.size.width, self.toolbar.bounds.size.height);
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
    
    [self animateCategorySelection:self.categoriesButtonCollection[0]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData:) name:VAKUpdateDataNotification object:nil];
}

#pragma mark - notification method

- (void)updateData:(NSNotification *)notification {
    self.selectedNewsChannel = notification.userInfo[@"url"];
    self.news = [VAKDataManager allEntitiesWithName:VAKNewsEntityName predicate:[self predicate] sortDescriptor:[self sortDescriptor]];
//    NSLog(@"%ld main screen VC", self.news.count);
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

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

- (NSString *)nameSelectedCategory {
    if ([self.selectedNewsChannel isEqualToString:VAKNewsURL[VAKURLNewsTutBy]]) {
        return VAKNameCategoriesTutBy[self.selectedCategoryTag];
    }
    else if ([self.selectedNewsChannel isEqualToString:VAKNewsURL[VAKURLNewsOnlinerBy]]) {
        return VAKNameCategoriesOnlinerBy[self.selectedCategoryTag];
    }
    return VAKNameCategoriesLentaRu[self.selectedCategoryTag];
}

- (NSPredicate *)predicate {
    NSPredicate *predicate;
    if (self.selectedCategoryTag > 0) {
        predicate = [NSPredicate predicateWithFormat:@"category.channel.url == %@ AND category.name == %@", self.selectedNewsChannel, [self nameSelectedCategory]];
    }
    else {
        predicate = [NSPredicate predicateWithFormat:@"category.channel.url == %@", self.selectedNewsChannel];
    }
    return predicate;
}

- (NSSortDescriptor *)sortDescriptor {
    return [NSSortDescriptor sortDescriptorWithKey:VAKSortDescriptorKey ascending:YES];
}

#pragma mark - actions with slide menu

- (IBAction)slideMenuButtonPressed:(UIBarButtonItem *)sender {
    [[VAKSlideMenuViewController sharedSlideMenu] showMenu];
    [VAKSlideMenuViewController sharedSlideMenu].delegate = self;
    [UIView animateWithDuration:0.25f animations:^{
        self.collectionView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.f, self.collectionView.frame.origin.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
        self.navigationController.navigationBar.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.f, self.navigationController.navigationBar.frame.origin.y, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height);
        self.toolbar.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.f, self.toolbar.frame.origin.y, self.toolbar.bounds.size.width, self.toolbar.bounds.size.height);
    }];
}

#pragma mark - UIToolbar actions

- (IBAction)selectCategoryButtonPressed:(UIButton *)sender {
    
    if (sender.tag != self.selectedCategoryTag) {
        if (self.selectedCategoryTag >= 0) {
            [self animateCategoryCancellation:self.categoriesButtonCollection[self.selectedCategoryTag]];
        }
        [self animateCategorySelection:sender];
        self.selectedCategoryTag = sender.tag;
        self.title = VAKTitleCategories[sender.tag];
        self.news = [VAKDataManager allEntitiesWithName:VAKNewsEntityName predicate:[self predicate] sortDescriptor:[self sortDescriptor]];
        [self.collectionView reloadData];
    }

}

#pragma mark - UIToolbar animation

- (void)animateCategoryCancellation:(UIButton *)button {
    [button setImage:[UIImage imageNamed:VAKLittleImageName[button.tag]] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsZero;
    button.layer.cornerRadius = 0;
    button.layer.bounds = button.layer.bounds = CGRectMake(0.f, 0.f, 25.f, 25.f);;
    button.layer.backgroundColor = [UIColor clearColor].CGColor;
}

- (void)animateCategorySelection:(UIButton *)button {
    [button setImage:[UIImage imageNamed:VAKBigImageName[button.tag]] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0.f, 0.f, 25.f, 0.f);
    button.layer.bounds = CGRectMake(0.f, 0.f, 100.f, 100.f);
    button.layer.backgroundColor = [UIColor colorWithRed:55.f / 255.f green:55.f / 255.f blue:55.f / 255.f alpha:1.f].CGColor;
    button.layer.cornerRadius = 50.f;
}

#pragma mark - deallocate

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
