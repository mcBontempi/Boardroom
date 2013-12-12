#import <Foundation/Foundation.h>

@interface Uploader : NSObject

- (void)uploadPNG:(NSData *)data hash:(NSString *)hash room:(NSString *)room;

- (BOOL)isBusy;

@end
