#import "VAKDataManager.h"
#import "Category+CoreDataClass.h"
#import "News+CoreDataClass.h"
#import "Channel+CoreDataClass.h"

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

+ (void)channelWithURL:(NSString *)url category:(Category *)category {
    NSArray *channels = [VAKDataManager allEntitiesWithName:VAKChannelEntityName predicate:[NSPredicate predicateWithFormat:@"url == %@", url] sortDescriptor:nil];
    Channel *channel;
    if (channels.count > 0) {
        channel = channels[0];
    }
    else {
        channel = (Channel *)[VAKDataManager entityWithName:VAKChannelEntityName];
        channel.url = url;
    }
    [channel addCategoriesObject:category];
    category.channel = channel;
}

+ (Category *)categoryWithName:(NSString *)name news:(News *)news {
    NSArray *categories = [VAKDataManager allEntitiesWithName:VAKCategoryEntityName predicate:[NSPredicate predicateWithFormat:@"name == %@", name] sortDescriptor:nil];
    Category *entityCategory;
    if (categories.count > 0) {
        entityCategory = categories[0];
    }
    else {
        entityCategory = (Category *)[VAKDataManager entityWithName:VAKCategoryEntityName];
        entityCategory.name = name;
    }
    news.category = entityCategory;
    [entityCategory addNewsObject:news];
    return entityCategory;
}

+ (NSArray *)allEntitiesWithName:(NSString *)name predicate:(NSPredicate *)predicate sortDescriptor:(NSSortDescriptor *)sortDescriptor {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:name];
    [request setPredicate:predicate];
    if (sortDescriptor) {
        [request setSortDescriptors:@[sortDescriptor]];
    }
    NSArray *entities = [[VAKDataManager sharedManager].managedObjectContext executeFetchRequest:request error:nil];
    return entities;
}

+ (NSManagedObject *)entityWithName:(NSString *)name {
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:[VAKDataManager sharedManager].managedObjectContext];
    return object;
}

+ (void)deleteEntitiesWithChannelURL:(NSString *)url {
    NSArray *channels = [VAKDataManager allEntitiesWithName:VAKChannelEntityName predicate:[NSPredicate predicateWithFormat:@"url == %@", url] sortDescriptor:nil];
    for (Channel *item in channels) {
        [[VAKDataManager sharedManager].managedObjectContext deleteObject:item];
    }
    [[VAKDataManager sharedManager].managedObjectContext save:nil];
}

@end
