#import <Foundation/Foundation.h>

@interface VAKNewsParser : NSObject

+ (void)newsWithData:(NSArray *)data urlIdentifier:(NSUInteger)urlIdentifier;

@end

@interface VAKNewsParser (ParserNewsWithTutBy)

+ (void)parserNewsWithTutByData:(NSArray *)data;

@end
