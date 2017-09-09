#import "Category+CoreDataClass.h"
#import "Channel+CoreDataClass.h"

#import "News+CoreDataClass.h"

@implementation Category

+ (NSFetchRequest<Category *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"Category"];
}

@dynamic name;
@dynamic news;
@dynamic channel;

@end
