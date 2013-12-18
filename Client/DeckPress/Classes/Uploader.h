#import <Foundation/Foundation.h>
#import "PageData.h"

@interface Uploader : NSObject

- (void)makePageDataForURL:(NSURL *)docURL index:(NSUInteger)index room:(NSString *)room;
- (void)doUpload:(PageData *)pageData room:(NSString *)room;
- (BOOL)isBusy;

@end
