#import "VAKNewsParser.h"
#import "VAKDataManager.h"
#import "News+CoreDataClass.h"
#import "Category+CoreDataClass.h"
#import "VAKConstantsNewsURL.h"

static NSString * const VAKDateFormat = @"E, d MMM yyyy HH:mm:ss Z";

static NSString * const VAKSourceLentaRu = @"lenta.ru";
static NSString * const VAKTitleIdentifier = @"title";
static NSString * const VAKLinkIdentifier = @"link";
static NSString * const VAKPubDateIdentifier = @"pubDate";
static NSString * const VAKCategoryIdentifier = @"category";
static NSString * const VAKEnclosureIdentifier = @"enclosure";
static NSString * const VAKDescriptionIdentifier = @"description";
static NSString * const VAKTextIdentifier = @"__text__";
static NSString * const VAKAuthorIdentifier = @"atom:author";
static NSString * const VAKNameIdentifier = @"atom:name";
static NSString * const VAKUrlImageIdentifier = @"url";
static NSString * const VAKCreatorIdentifier = @"dc:creator";
static NSString * const VAKMediaIdentifier = @"media:thumbnail";

@interface VAKNewsParser (ParserNewsWithTutBy)

+ (void)parserNewsWithTutByData:(NSArray *)data completionBlock:(void(^)(void))completionBlock;

@end

@interface VAKNewsParser (ParserNewsWithOnlinerBy)

+ (void)parserNewsWithOnlinerByData:(NSArray *)data completionBlock:(void(^)(void))completionBlock;

@end

@interface VAKNewsParser (ParserNewsWithLentaRu)

+ (void)parserNewsWithLentaRuData:(NSArray *)data completionBlock:(void(^)(void))completionBlock;

@end

@interface NSDate (DateWithFormat)

+ (NSDate *)dateWithString:(NSString *)string;

@end

@implementation VAKNewsParser

+ (void)newsWithData:(NSArray *)data identifierUrlChannel:(NSUInteger)identifierUrlChannel completionBlock:(void (^)(void))completionBlock {
    switch (identifierUrlChannel) {
        case 0:
            [self parserNewsWithTutByData:data completionBlock:completionBlock];
            break;
        case 1:
            [self parserNewsWithOnlinerByData:data completionBlock:completionBlock];
            break;
        case 2:
            [self parserNewsWithLentaRuData:data completionBlock:completionBlock];
            break;
        default:
            break;
    }
}

@end

@implementation VAKNewsParser (ParserNewsWithTutBy)

+ (void)parserNewsWithTutByData:(NSArray *)data completionBlock:(void (^)(void))completionBlock {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [VAKDataManager deleteEntitiesWithChannelURL:VAKNewsURL[VAKURLNewsTutBy]];
        for (NSDictionary *item in data) {
            News *news = (News *)[VAKDataManager entityWithName:VAKNewsEntityName];
            news.title = item[VAKTitleIdentifier];
            news.link = item[VAKLinkIdentifier];
            news.pubDate = [NSDate dateWithString:item[VAKPubDateIdentifier]];
            id authors = item[VAKAuthorIdentifier];
            if ([authors isKindOfClass:[NSDictionary class]]) {
                news.source = authors[VAKNameIdentifier];
            }
            else if ([authors isKindOfClass:[NSArray class]]) {
                news.source = authors[0][VAKNameIdentifier];
            }
            news.imageURL = item[VAKEnclosureIdentifier][VAKUrlImageIdentifier];
            NSArray *componentsDescription = [item[VAKDescriptionIdentifier] componentsSeparatedByString:@"/>"];
            if (componentsDescription.count > 1) {
                componentsDescription = [componentsDescription[1] componentsSeparatedByString:@"<br clear=\"all\""];
                news.specification = componentsDescription[0];
            }
            NSString *category = item[VAKCategoryIdentifier][VAKTextIdentifier];
            [VAKDataManager categoryWithName:category channelURL:VAKNewsURL[VAKURLNewsTutBy] news:news];
        }
        [[VAKDataManager sharedManager].managedObjectContext save:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock();
        });
    });
}

@end

@implementation VAKNewsParser (ParserNewsWithOnlinerBy)

+ (void)parserNewsWithOnlinerByData:(NSArray *)data completionBlock:(void (^)(void))completionBlock {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [VAKDataManager deleteEntitiesWithChannelURL:VAKNewsURL[VAKURLNewsOnlinerBy]];
        for (NSDictionary *item in data) {
            News *news = (News *)[VAKDataManager entityWithName:VAKNewsEntityName];
            news.title = item[VAKTitleIdentifier];
            news.link = item[VAKLinkIdentifier];
            news.pubDate = [NSDate dateWithString:item[VAKPubDateIdentifier]];
            news.source = item[VAKCreatorIdentifier];
            news.imageURL = item[VAKMediaIdentifier][VAKUrlImageIdentifier];
            NSArray *componentsDescription = [item[VAKDescriptionIdentifier] componentsSeparatedByString:@"<p>"];
            if (componentsDescription.count > 0) {
                componentsDescription = [componentsDescription[2] componentsSeparatedByString:@"</p>"];
                news.specification = componentsDescription[0];
            }
            NSString *category = item[VAKCategoryIdentifier];
            [VAKDataManager categoryWithName:category channelURL:VAKNewsURL[VAKURLNewsOnlinerBy] news:news];
        }
        [[VAKDataManager sharedManager].managedObjectContext save:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock();
        });
    });
}

@end

@implementation VAKNewsParser (ParserNewsWithLentaRu)

+ (void)parserNewsWithLentaRuData:(NSArray *)data completionBlock:(void (^)(void))completionBlock {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [VAKDataManager deleteEntitiesWithChannelURL:VAKNewsURL[VAKURLNewsLentaRu]];
        for (NSDictionary *item in data) {
            News *news = (News *)[VAKDataManager entityWithName:VAKNewsEntityName];
            news.title = item[VAKTitleIdentifier];
            news.link = item[VAKLinkIdentifier];
            news.pubDate = [NSDate dateWithString:item[VAKPubDateIdentifier]];
            news.source = VAKSourceLentaRu;
            news.imageURL = item[VAKEnclosureIdentifier][VAKUrlImageIdentifier];
            news.specification = item[VAKDescriptionIdentifier];
            NSString *category = item[VAKCategoryIdentifier];
            [VAKDataManager categoryWithName:category channelURL:VAKNewsURL[VAKURLNewsLentaRu] news:news];
        }
        [[VAKDataManager sharedManager].managedObjectContext save:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock();
        });
    });
}

@end

@implementation NSDate (DateWithFormat)

+ (NSDate *)dateWithString:(NSString *)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = VAKDateFormat;
    formatter.timeZone = [NSTimeZone systemTimeZone];
    NSDate *date = [formatter dateFromString:string];
    return date;
}

@end
