#ifndef VAKNewsURL_h
#define VAKNewsURL_h

typedef NS_ENUM(NSUInteger, URLNews) {
    VAKURLNewsTutBy,
    VAKURLNewsOnlinerBy,
    VAKURLNewsLentaRu
};

static NSString * const VAKNewsURL[] = {
    [VAKURLNewsTutBy] = @"https://news.tut.by/rss",
    [VAKURLNewsOnlinerBy] = @"https:www.onliner.by/feed",
    [VAKURLNewsLentaRu] = @"https://lenta.ru/rss"
};

#endif
