#import "UploadOperation.h"
#import "ImageMaker.h"
#import <AFNetworking/AFHTTPClient.h>

typedef NS_ENUM(NSInteger, UploadState) {
  UploadStateNotStarted = 0,
  UploadStateRequestQueued,
  UploadStateRequestFailedAwaitingNetworkConnection,
  UploadStateRequestFailedAwaitingRetry,
  UploadStateRequestFailedAwaitingAuthentication,
  UploadStateRequestFailed,
  UploadStateRequestSucceeded,
};

@interface UploadOperation ()
@property UploadState state;
@end

@implementation UploadOperation
{
  UIView *_view;
  AFHTTPClient *_client;
}

- (id)initWithView:(UIView *)view
{
  if (self = [super init]) {
    _state = UploadStateNotStarted;
    _view = view;
    
    NSString *address;
#if LOCAL
    address  = @"http://localhost:8080";
#else
    address = @"http://162.13.5.127:8080";
#endif
    _client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:address]];
    
  }
  return self;
}


- (BOOL)isFinished
{
  return self.state == UploadStateRequestSucceeded;
}

- (void)start
{
  UIImage *image = [ImageMaker captureScreen:_view];
  
  
  NSData *data = UIImagePNGRepresentation(image);
  
  NSLog(@"image size %d", data.length);
  
  NSLog(@"end");
  
  NSLog(@"height = %f", image.size.height);
  
  _state = UploadStateRequestQueued;
  
  NSMutableURLRequest *request = [_client multipartFormRequestWithMethod:@"POST" path:@"upload" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
    [formData appendPartWithFileData:data name:@"myFile" fileName:@"temp2.png" mimeType:@"image/png"];
  }];
  __weak UploadOperation *weakSelf = self;
  AFHTTPRequestOperation *operation = [_client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject){
    weakSelf.state = UploadStateRequestSucceeded;
  } failure:^(AFHTTPRequestOperation *operation, NSError *error){
    weakSelf.state = UploadStateRequestFailed;
  }];
  [_client enqueueHTTPRequestOperation:operation];
}

@end
