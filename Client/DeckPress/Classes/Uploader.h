#import <Foundation/Foundation.h>
#import "PageData.h"
#import "PageGeneratorOperation.h"

@interface Uploader : NSObject

- (id)initWithRoom:(NSString *)room;
- (void)makePageDataForURL:(NSURL *)docURL index:(NSUInteger)index succcessBlock:(pageDataBlock) successBlock;
- (void)doUpload:(PageData *)pageData;
- (BOOL)isBusy;

@end
