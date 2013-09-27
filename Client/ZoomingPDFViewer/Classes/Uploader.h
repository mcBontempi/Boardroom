#import <Foundation/Foundation.h>

@interface Uploader : NSObject

- (void)progressivelyUploadView:(UIView *)view room:(NSString *)room;

- (void)uploadView:(UIView *)view room:(NSString *)room;

- (void)uploadImage:(UIImage *)image room:(NSString *)room;

- (BOOL)isBusy;

@end
