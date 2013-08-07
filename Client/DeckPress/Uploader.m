#import "Uploader.h"
#import "Slide.h"
#import "UploadOperation.h"
#import "UploadOperationQueue.h"

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

- (void)uploadSlide:(Slide *)slide
{
  [_queue]
}

@end
