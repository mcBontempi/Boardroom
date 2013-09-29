#import <Foundation/Foundation.h>

@interface UploadOperation : NSOperation

- (id)initWithData:(NSData *)data room:(NSString *)room;

@end
