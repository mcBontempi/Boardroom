#import "Uploader.h"
#import "Slide.h"
#import "UploadOperation.h"
#import "UploadOperationQueue.h"
#import "ImageMaker.h"

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

- (void)progressivelyUploadView:(UIView *)view
{
  [_queue reset];
  //UIView *zoomedView = [ImageMaker createZoomedView:1 view:view];
  for (float i = 0.2 ; i <= 2.0 ; i+= i) {
    UIImage *image = [ImageMaker captureScreen:view scale:i];
    UploadOperation *uploadOperation = [[UploadOperation alloc] initWithImage:image scale:i];
    NSLog(@"scale = %f", i);
    [_queue addOperation:uploadOperation];
  }
}

@end
