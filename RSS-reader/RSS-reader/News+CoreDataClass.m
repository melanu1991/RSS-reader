#import "News+CoreDataClass.h"

@implementation News

+ (NSFetchRequest<News *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"News"];
}

@dynamic title;
@dynamic imageURL;
@dynamic pubDate;
@dynamic specification;
@dynamic source;
@dynamic category;

@end
