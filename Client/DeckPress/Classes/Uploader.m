#import "Uploader.h"
#import "UploadOperation.h"
#import "UploadOperationQueue.h"
#import "CheckOperation.h"

// uploader can only check for / upload one image at a time

@implementation Uploader
{
    UploadOperationQueue *_queue;
    NSString *_room;
}

- (id) initWithRoom:(NSString *)room
{
    if (self = [super init]) {
        _queue = [[UploadOperationQueue alloc] init];
        _room = room;
    }
    return self;
}

- (void)makePageDataForURL:(NSURL *)docURL index:(NSUInteger)index succcessBlock:(pageDataBlock) successBlock
{
    PageGeneratorOperation *operation = [[PageGeneratorOperation alloc] initWitdocURL:docURL index:index successBlock:^(PageData *pageData) {
        successBlock(pageData);
    }];
    
    [_queue addOperation:operation];
}

- (void)doUpload:(PageData *)pageData
{
    CheckOperation *checkOperation = [[CheckOperation alloc] initWithHash:pageData.hash room:_room falureBlock: ^{
        UploadOperation *uploadOperation = [[UploadOperation alloc] initWithData:pageData.png hash:pageData.hash room:_room];
        [_queue addOperation:uploadOperation];} ];
    [_queue addOperation:checkOperation];
}

- (BOOL)isBusy
{
    return _queue.isBusy;
}

@end
