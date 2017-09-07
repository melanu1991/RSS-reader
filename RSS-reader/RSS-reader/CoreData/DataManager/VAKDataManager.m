#import "VAKDataManager.h"
#import "Category+CoreDataClass.h"
#import "News+CoreDataClass.h"

@implementation VAKDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Singleton

+ (VAKDataManager *)sharedManager {
    static VAKDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VAKDataManager alloc] init];
    });
    return manager;
}

#pragma mark - Core Data Stack

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RSS_reader" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RSS_reader.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    }
    return _persistentStoreCoordinator;
}

#pragma mark - Save Context

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@ %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Application Documents Directory

-(NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

@implementation VAKDataManager (WorkWithData)

+ (void)categoryWithName:(NSString *)name news:(News *)news {
    NSArray *categories = [VAKDataManager allEntitiesWithName:VAKCategoryEntity predicate:[NSPredicate predicateWithFormat:@"name == %@", name]];
    Category *entityCategory;
    if (categories.count > 0) {
        entityCategory = categories[0];
    }
    else {
        entityCategory = (Category *)[VAKDataManager entityWithName:VAKCategoryEntity];
        entityCategory.name = name;
    }
    news.category = entityCategory;
    [entityCategory addNewsObject:news];
}

+ (NSArray *)allEntitiesWithName:(NSString *)name predicate:(NSPredicate *)predicate {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:name];
    [request setPredicate:predicate];   
    NSArray *entities = [[VAKDataManager sharedManager].managedObjectContext executeFetchRequest:request error:nil];
    return entities;
}

+ (NSManagedObject *)entityWithName:(NSString *)name {
    if ([name isEqualToString:VAKNewsEntity]) {
        News *news = [NSEntityDescription insertNewObjectForEntityForName:VAKNewsEntity inManagedObjectContext:[VAKDataManager sharedManager].managedObjectContext];
        return news;
    }
    else if ([name isEqualToString:VAKCategoryEntity]) {
        Category *category = [NSEntityDescription insertNewObjectForEntityForName:VAKCategoryEntity inManagedObjectContext:[VAKDataManager sharedManager].managedObjectContext];
        return category;
    }
    return nil;
}

+ (void)deleteAllEntities {
    NSArray *news = [VAKDataManager allEntitiesWithName:VAKNewsEntity predicate:nil];
    NSArray *categories = [VAKDataManager allEntitiesWithName:VAKCategoryEntity predicate:nil];
    for (Category *item in categories) {
        [[VAKDataManager sharedManager].managedObjectContext deleteObject:item];
    }
    for (News *item in news) {
        [[VAKDataManager sharedManager].managedObjectContext deleteObject:item];
    }
    [[VAKDataManager sharedManager].managedObjectContext save:nil];
}

@end















