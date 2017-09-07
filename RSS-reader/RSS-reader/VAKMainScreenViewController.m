#import "VAKMainScreenViewController.h"
#import "VAKSlideMenuViewController.h"
#import "VAKDataManager.h"
#import "News+CoreDataClass.h"
#import "Category+CoreDataClass.h"
#import "VAKNewsTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString * const VAKSlideMenuViewControllerIdentifier = @"VAKSlideMenuViewController";
static NSString * const VAKNibNameIdentifier = @"VAKNewsTableViewCell";
static NSString * const VAKCellReuseIdentifier = @"newsCell";

@interface VAKMainScreenViewController ()

@property (strong, nonatomic) VAKSlideMenuViewController *slideMenuVC;
@property (strong, nonatomic) NSArray *news;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation VAKMainScreenViewController

#pragma mark - lazy getters

- (NSArray *)news {
    if (!_news) {
        _news = [VAKDataManager allEntitiesWithName:VAKNewsEntity predicate:nil];
    }
    return _news;
}

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
//    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    [self.tableView registerNib:[UINib nibWithNibName:VAKNibNameIdentifier bundle:nil] forCellReuseIdentifier:VAKCellReuseIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.news.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VAKNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VAKCellReuseIdentifier forIndexPath:indexPath];
//    if (!cell) {
//        cell = [[VAKNewsTableViewCell alloc] init];
//    }
    News *news = self.news[indexPath.row];
    cell.title.text = news.title;
    cell.specification.text = news.specification;
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - actions

- (IBAction)slideMenuButtonPressed:(UIBarButtonItem *)sender {
    
    if (!self.slideMenuVC.isSlideMenu) {
        [self.slideMenuVC showMenu];
    }
    else {
        [self.slideMenuVC hideMenu];
    }
    
}

@end
