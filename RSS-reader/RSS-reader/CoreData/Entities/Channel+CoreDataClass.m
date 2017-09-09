#import "Channel+CoreDataClass.h"
#import "Category+CoreDataClass.h"

@implementation Channel

+ (NSFetchRequest<Channel *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"Channel"];
}

@dynamic url;
@dynamic categories;

@end
