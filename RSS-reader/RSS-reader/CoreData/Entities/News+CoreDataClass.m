#import "News+CoreDataClass.h"
#import "Category+CoreDataClass.h"

@implementation News

+ (NSFetchRequest<News *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"News"];
}

@dynamic imageURL;
@dynamic pubDate;
@dynamic source;
@dynamic specification;
@dynamic title;
@dynamic category;
@dynamic link;

@end
