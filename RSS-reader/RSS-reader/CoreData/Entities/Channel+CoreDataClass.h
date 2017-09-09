#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category;

@interface Channel : NSManagedObject

+ (NSFetchRequest<Channel *> *_Nonnull)fetchRequest;

@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, retain) NSSet<Category *> *categories;

@end

@interface Channel (CoreDataGeneratedAccessors)

- (void)addCategoriesObject:(Category *_Nullable)value;
- (void)removeCategoriesObject:(Category *_Nullable)value;
- (void)addCategories:(NSSet<Category *> *_Nullable)values;
- (void)removeCategories:(NSSet<Category *> *_Nullable)values;

@end
