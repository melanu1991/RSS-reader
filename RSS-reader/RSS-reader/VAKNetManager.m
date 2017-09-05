#import "VAKNetManager.h"
#import "BNRSSFeedParser.h"
#import "BNRSSFeed.h"

@interface VAKNetManager ()

@property (strong, nonatomic) BNRSSFeedParser *feedParse;

@end

@implementation VAKNetManager

#pragma mark - lazy getters

- (BNRSSFeedParser *)feedParse {
    if (!_feedParse) {
        _feedParse = [[BNRSSFeedParser alloc] init];
    }
    return _feedParse;
}

#pragma mark - Singleton

+ (instancetype)sharedManager {
    static VAKNetManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

#pragma mark - load data

- (void)loadDataWithPath:(NSString *)path {
    
    NSURL *url = [NSURL URLWithString:path];
    [self.feedParse parseFeedURL:url withETag:nil untilPubDate:nil success:^(NSHTTPURLResponse *response, BNRSSFeed *feed) {
        
        
        
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        
        
        
    }];
    
}

@end
