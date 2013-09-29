#import <Foundation/Foundation.h>

@interface Uploader : NSObject

- (void)uploadImage:(UIImage *)image room:(NSString *)room;

- (BOOL)isBusy;

@end
