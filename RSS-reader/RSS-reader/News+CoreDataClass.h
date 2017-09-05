#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface News : NSManagedObject

+ (NSFetchRequest<News *> *_Nonnull)fetchRequest;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *imageURL;
@property (nullable, nonatomic, copy) NSDate *pubDate;
@property (nullable, nonatomic, copy) NSString *specification;
@property (nullable, nonatomic, copy) NSString *source;
@property (nullable, nonatomic, copy) NSString *category;

@end