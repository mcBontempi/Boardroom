#import <Foundation/Foundation.h>

@interface Uploader : NSObject

- (void)progressivelyUploadView:(UIView *)view room:(NSString *)room;

@end
