#import "VAKNSString+ValidatePhoneNumber.h"

@implementation NSString (ValidatePhoneNumber)

- (BOOL)isValidPhoneNumber {
    NSString *pattern = @"^[+][3][7][5][(]((44)|(25)|(29)|(33))[)][1-9]\\d{2}[-]\\d{2}[-]\\d{2}";
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger number = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
    if (number > 0 && !error) {
        return YES;
    }
    return NO;
}

@end
