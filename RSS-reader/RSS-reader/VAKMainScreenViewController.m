#import "VAKMainScreenViewController.h"
#import "VAKSlideMenuViewController.h"
#import "VAKDataManager.h"
#import "News+CoreDataClass.h"
#import "Category+CoreDataClass.h"
#import "VAKNewsTableViewCell.h"
#import "VAKWebViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import "VAKNewsCollectionViewCell.h"

static NSString * const VAKSlideMenuViewControllerIdentifier = @"VAKSlideMenuViewController";
static NSString * const VAKWebViewControllerIdentifier = @"VAKWebViewController";
static NSString * const VAKNibNameIdentifier = @"VAKNewsTableViewCell";
static NSString * const VAKCellReuseIdentifier = @"newsCell";
static NSString * const VAKSortDescriptorKey = @"pubDate";

@interface VAKMainScreenViewController ()

@property (strong, nonatomic) VAKSlideMenuViewController *slideMenuVC;
@property (strong, nonatomic) NSArray *news;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign, nonatomic) NSInteger columnCount;
@property (assign, nonatomic) NSInteger miniInteriorSpacing;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 140.f;
//    [self.tableView registerNib:[UINib nibWithNibName:VAKNibNameIdentifier bundle:nil] forCellReuseIdentifier:VAKCellReuseIdentifier];
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
//    [self.tableView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.news.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VAKNewsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"newsCell" forIndexPath:indexPath];
    News *news = self.news[indexPath.row];
    cell.newsTitle.text = news.title;
    return cell;
}

#pragma mark - UICollectionViewDelegate



//#pragma mark - UITableViewDataSource
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.news.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    VAKNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VAKCellReuseIdentifier forIndexPath:indexPath];
//    
//    News *news = self.news[indexPath.row];
//    
//    cell.title.text = [self formattedStringWithNews:news];
//    [cell.image sd_setShowActivityIndicatorView:YES];
//    [cell.image sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [cell.image sd_setImageWithURL:[NSURL URLWithString:news.imageURL] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
//    
//    return cell;
//}

//#pragma mark - UITableViewDelegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    VAKWebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:VAKWebViewControllerIdentifier];
//    News *news = self.news[indexPath.row];
//    webVC.link = news.link;
//    [self.navigationController pushViewController:webVC animated:YES];
//}

#pragma mark - helpers

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    News *news = [self.news objectAtIndex:indexPath.row];
    CGFloat labelSize = [self calculateHeightForLbl:news.title width:self.view.frame.size.width / 2 - 20];
//    UIImage *image = news;
    return CGSizeMake(self.view.frame.size.width / 2 - 20, labelSize + 30 + 120);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}


-(float)calculateHeightForLbl:(NSString*)text width:(float)width {
    CGSize constraint = CGSizeMake(width,20000.0f);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [text boundingRectWithSize:constraint
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                            context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height+10;
}

- (NSString *)formattedStringWithNews:(News *)news {
    
    NSMutableString *string = [NSMutableString string];
    
    [string appendString:news.title];
    [string appendString:@"\n"];
    [string appendString:news.specification];
    [string appendString:@"\n"];
    [string appendString:news.source];
    [string appendString:@"\n"];
    [string appendString:news.pubDate.description];
    
    return [string copy];
}

#pragma mark - actions

- (IBAction)slideMenuButtonPressed:(UIBarButtonItem *)sender {
    
    if (!self.slideMenuVC.isSlideMenu) {
        [self.slideMenuVC showMenu];
    }
    else {
        [self.slideMenuVC hideMenu];
    }
    
}

#pragma mark - deallocate

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
