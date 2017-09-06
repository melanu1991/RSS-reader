#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class News;

@interface Category : NSManagedObject

+ (NSFetchRequest<Category *> *_Nonnull)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<News *> *news;

@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addNewsObject:(News *_Nullable)value;
- (void)removeNewsObject:(News *_Nullable)value;
- (void)addNews:(NSSet<News *> *_Nullable)values;
- (void)removeNews:(NSSet<News *> *_Nullable)values;

@end
