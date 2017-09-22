#ifndef VAKConstantsEmailsChannels_h
#define VAKConstantsEmailsChannels_h

typedef NS_ENUM(NSUInteger, EmailChannel) {
    VAKEmailChannelTutBy,
    VAKEmailChannelOnlinerBy,
    VAKEmailChannelLentaRu
};

static NSString * const VAKEmailsChannels[] = {
    [VAKEmailChannelTutBy] = @"nak@onliner.by",
    [VAKEmailChannelOnlinerBy] = @"nn@tutby.com",
    [VAKEmailChannelLentaRu] = @"letter@lenta-co.ru"
};

#endif
