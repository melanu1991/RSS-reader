#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

static NSString * const VAKNewsEntity = @"News";
static NSString * const VAKCategoryEntity = @"Category";

@class News;

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
+ (void)categoryWithName:(NSString *)name news:(News *)news;
+ (NSArray *)allEntitiesWithName:(NSString *)name predicate:(NSPredicate *)predicate;
+ (void)deleteAllEntities;

@end
