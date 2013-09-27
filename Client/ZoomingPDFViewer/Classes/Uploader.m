#import "Uploader.h"
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

- (void)progressivelyUploadView:(UIView *)view room:(NSString *)room
{
  [_queue reset];
  //UIView *zoomedView = [ImageMaker createZoomedView:1 view:view];
  for (float i = 0.5 ; i <= 2.0 ; i+= 0.5) {
    UIImage *image = [ImageMaker captureScreen:view scale:i];
    UploadOperation *uploadOperation = [[UploadOperation alloc] initWithImage:image scale:i room:room];
    NSLog(@"scale = %f", i);
    [_queue addOperation:uploadOperation];
  }
}



- (void)uploadView:(UIView *)view room:(NSString *)room
{
  [_queue reset];
    UIImage *image = [ImageMaker captureScreen:view scale:1.0];
    UploadOperation *uploadOperation = [[UploadOperation alloc] initWithImage:image scale:1.0 room:room];
    [_queue addOperation:uploadOperation];
}


- (BOOL)isBusy
{
  return _queue.isBusy;
}

@end
