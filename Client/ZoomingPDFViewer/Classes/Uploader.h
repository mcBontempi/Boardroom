#import <Foundation/Foundation.h>

@interface Uploader : NSObject

- (void)uploadImage:(UIImage *)image room:(NSString *)room;

- (void)uploadPNG:(NSData *)data hash:(NSString *)hash room:(NSString *)room;

- (BOOL)isBusy;

+ (NSString*)MD5StringOfData:(NSData*)inputData;

@end
