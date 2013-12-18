#import "Uploader.h"
#import "UploadOperation.h"
#import "UploadOperationQueue.h"
#import "CheckOperation.h"
#import "PageGeneratorOperation.h"
#import "PageData.h"

// uploader can only check for / upload one image at a time

@implementation Uploader
{
  UploadOperationQueue *_queue;
}

- (id) init
{
  if (self = [super init]) {
    _queue = [[UploadOperationQueue alloc] init];
  }
  return self;
}

- (void)makePageDataForURL:(NSURL *)docURL index:(NSUInteger)index room:(NSString *)room
{
    
    //[_queue cancelOperationWithTypeArray:@[CheckOperation.class, UploadOperation.class]];
    
    //[_queue cancelAll]
    
    
    //__weak Uploader *weakSelf = self;
    
    PageGeneratorOperation *operation = [[PageGeneratorOperation alloc] initWitdocURL:docURL index:index successBlock:^(PageData *pageData) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pageChangedNotification" object:pageData];
       // [weakSelf uploadPNG:pageData.png hash:pageData.hash room:room];
    }];

    [_queue addOperation:operation];
}

- (void)doUpload:(PageData *)pageData room:(NSString *)room
{
   CheckOperation *checkOperation = [[CheckOperation alloc] initWithHash:pageData.hash room:room falureBlock: ^{
   UploadOperation *uploadOperation = [[UploadOperation alloc] initWithData:pageData.png hash:pageData.hash room:room];
   [_queue addOperation:uploadOperation];} ];
   [_queue addOperation:checkOperation];
}

- (BOOL)isBusy
{
  return _queue.isBusy;
}

@end
