#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

static NSString * const VAKNewsEntityName = @"News";
static NSString * const VAKCategoryEntityName = @"Category";
static NSString * const VAKChannelEntityName = @"Channel";

@class News, Category;

@interface VAKDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (VAKDataManager *)sharedManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

@interface VAKDataManager (WorkWithData)

+ (NSManagedObject *)entityWithName:(NSString *)name;
+ (void)channelWithURL:(NSString *)url category:(Category *)category;
+ (Category *)categoryWithName:(NSString *)name news:(News *)news;
+ (NSArray *)allEntitiesWithName:(NSString *)name predicate:(NSPredicate *)predicate sortDescriptor:(NSSortDescriptor *)sortDescriptor;
+ (void)deleteEntitiesWithChannelURL:(NSString *)url;

@end
