#import "VAKMainScreenViewController.h"
#import "VAKSlideMenuViewController.h"
#import "VAKDataManager.h"
#import "News+CoreDataClass.h"
#import "Category+CoreDataClass.h"
#import "VAKNewsTableViewCell.h"
#import "VAKWebViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString * const VAKSlideMenuViewControllerIdentifier = @"VAKSlideMenuViewController";
static NSString * const VAKWebViewControllerIdentifier = @"VAKWebViewController";
static NSString * const VAKNibNameIdentifier = @"VAKNewsTableViewCell";
static NSString * const VAKCellReuseIdentifier = @"newsCell";
static NSString * const VAKSortDescriptorKey = @"pubDate";

@interface VAKMainScreenViewController ()

@property (strong, nonatomic) VAKSlideMenuViewController *slideMenuVC;
@property (strong, nonatomic) NSArray *news;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 140.f;
    [self.tableView registerNib:[UINib nibWithNibName:VAKNibNameIdentifier bundle:nil] forCellReuseIdentifier:VAKCellReuseIdentifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData:) name:VAKUpdateDataNotification object:nil];
}

#pragma mark - notification method

- (void)updateData:(NSNotification *)notification {
    self.news = [VAKDataManager allEntitiesWithName:VAKNewsEntityName predicate:[NSPredicate predicateWithFormat:@"category.channel.url == %@", notification.userInfo[@"url"]] sortDescriptor:[NSSortDescriptor sortDescriptorWithKey:VAKSortDescriptorKey ascending:YES]];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.news.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VAKNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VAKCellReuseIdentifier forIndexPath:indexPath];
    News *news = self.news[indexPath.row];
    cell.title.text = news.title;
//    cell.specification.text = news.specification;
//    NSURL *url = [NSURL URLWithString:news.imageURL];
//    [cell.image sd_setImageWithURL:url placeholderImage:nil];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VAKWebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:VAKWebViewControllerIdentifier];
    News *news = self.news[indexPath.row];
    webVC.link = news.link;
    [self.navigationController pushViewController:webVC animated:YES];
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
