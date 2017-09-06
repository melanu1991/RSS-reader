#import "VAKNewsParser.h"

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

@implementation VAKNewsParser

+ (void)newsWithData:(NSArray *)data urlIdentifier:(NSUInteger)urlIdentifier {
    switch (urlIdentifier) {
        case 0:
            [self parserNewsWithTutByData:data];
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        default:
            break;
    }
}

@end

@implementation VAKNewsParser (ParserNewsWithTutBy)

+ (void)parserNewsWithTutByData:(NSArray *)data {
    
    NSString *title;
    NSString *link;
    NSString *pubDate;
    NSString *category;
    NSString *source;
    NSString *urlImage;
    NSString *description;
    
    for (NSDictionary *news in data) {
        title = news[VAKTitleIdentifier];
        link = news[VAKLinkIdentifier];
        pubDate = news[VAKPubDateIdentifier];
        category = news[VAKCategoryIdentifier][VAKTextIdentifier];
        id authors = news[VAKAuthorIdentifier];
        if ([authors isKindOfClass:[NSDictionary class]]) {
            source = authors[VAKNameIdentifier];
        }
        else if ([authors isKindOfClass:[NSArray class]]) {
            source = authors[0][VAKNameIdentifier];
        }
        urlImage = news[VAKEnclosureIdentifier][VAKUrlImageIdentifier];
        NSArray *componentsDescription = [news[VAKDescriptionIdentifier] componentsSeparatedByString:@"/>"];
        if (componentsDescription.count > 0) {
            componentsDescription = [componentsDescription[1] componentsSeparatedByString:@"<br clear=\"all\""];
            description = componentsDescription[0];
        }
    }
    
}

@end








