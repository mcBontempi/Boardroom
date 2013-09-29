#import <Foundation/Foundation.h>

@interface UploadOperation : NSOperation

- (id)initWithData:(NSData *)data hash:(NSString*)hash room:(NSString *)room;

@end
