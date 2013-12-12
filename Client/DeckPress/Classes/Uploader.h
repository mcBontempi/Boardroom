#import <Foundation/Foundation.h>

@interface Uploader : NSObject

- (void)makePageDataForURL:(NSURL *)docURL index:(NSUInteger)index room:(NSString *)room;


- (BOOL)isBusy;

@end
