#ifndef VAKSKPSMTPMessageServiceDelegate_h
#define VAKSKPSMTPMessageServiceDelegate_h

@protocol VAKSKPSMTPMessageServiceDelegate <NSObject>

- (void)confirmOfSendingMessage:(NSError *)error;

@end

#endif
