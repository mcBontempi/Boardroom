#import "Uploader.h"
#import "UploadOperation.h"
#import "UploadOperationQueue.h"
#import "CheckOperation.h"

// uploader can only check for / upload one image at a time

@implementation Uploader
{
  UploadOperationQueue *_queue;
  
  NSData *_data;
  NSString *_hash;
}

- (id) init
{
  if (self = [super init]) {
    _queue = [[UploadOperationQueue alloc] init];
  }
  return self;
}

- (void)uploadPNG:(NSData *)data hash:(NSString *)hash room:(NSString *)room
{
  _data = data;
  _hash = hash;
  
  NSLog(@"hash = %@", _hash);
  
   CheckOperation *checkOperation = [[CheckOperation alloc] initWithHash:_hash room:room falureBlock: ^{
   UploadOperation *uploadOperation = [[UploadOperation alloc] initWithData:_data hash:_hash room:room];
   [_queue addOperation:uploadOperation];} ];
   [_queue addOperation:checkOperation];
}

- (BOOL)isBusy
{
  return _queue.isBusy;
}

@end
