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
  assert(0);
}

- (void)uploadView:(UIView *)view
{
//  [_queue reset];
  
  UploadOperation *uploadOperation = [[UploadOperation alloc] initWithView:view];
 
  [_queue addOperation:uploadOperation];
  
}

@end
