#import <Foundation/Foundation.h>
#import "PageData.h"

@interface Uploader : NSObject

- (id)initWithRoom:(NSString *)room;

- (void)makePageDataForURL:(NSURL *)docURL index:(NSUInteger)index;
- (void)doUpload:(PageData *)pageData;
- (BOOL)isBusy;

@end
