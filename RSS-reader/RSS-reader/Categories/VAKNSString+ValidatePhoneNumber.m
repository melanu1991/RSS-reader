#import "VAKNSString+ValidatePhoneNumber.h"

@implementation NSString (ValidatePhoneNumber)

- (BOOL)isValidPhoneNumber {
    NSString *pattern = @"^[+][3][7][5][(](([4][4])|([2][5])|([2][9])|([3][3]))[)][1-9]\\d{2}[-]\\d{2}[-]\\d{2}";
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSLog(@"%@", error);
    NSUInteger number = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
    if (number > 0) {
        return YES;
    }
    return NO;
}

@end
