#import <Foundation/Foundation.h>

@interface UploadOperation : NSOperation

- (id)initWithImage:(UIImage *)image room:(NSString *)room;

@end
