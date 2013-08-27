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
  UIImage *_image;
  NSString *_room;
  float _scale;
  AFHTTPClient *_client;
}

- (id)initWithImage:(UIImage *)image scale:(float)scale room:(NSString *)room;
{
  if (self = [super init]) {
    _state = UploadStateNotStarted;
    _image = image;
    _scale = scale;
    _room = room;
    
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

- (BOOL)isExecuting
{
  return self.state == UploadStateRequestQueued;
}

- (BOOL)isReady
{
  return self.state == UploadStateNotStarted;
}

- (BOOL)isConcurrent
{
  return NO;
}

- (void)main
{
  NSData *data = UIImagePNGRepresentation(_image);
  
  NSLog(@"image size %d", data.length);
  
  NSLog(@"end");
  
  NSLog(@"height = %f", _image.size.height);
  
  [self transitionToState:UploadStateRequestQueued
     notifyChangesForKeys:@[@"isExecuting"]];
  
  NSMutableURLRequest *request = [_client multipartFormRequestWithMethod:@"POST" path:@"upload" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
    [formData appendPartWithFileData:data name:@"myFile" fileName:_room mimeType:@"image/png"];
  }];
  __weak UploadOperation *weakSelf = self;
  AFHTTPRequestOperation *operation = [_client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject){
    [weakSelf transitionToState:UploadStateRequestSucceeded notifyChangesForKeys:@[@"isExecuting", @"isFinished"]];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error){
    [weakSelf transitionToState:UploadStateRequestFailed notifyChangesForKeys:@[@"isExecuting", @"isFinished"]];
  }];
  [_client enqueueHTTPRequestOperation:operation];
}

- (void)cancel
{
  [[_client operationQueue] cancelAllOperations];
}

- (void)transitionToState:(UploadState)newState notifyChangesForKeys:(NSArray *)keys
{
  for (NSString *key in keys) {
    [self willChangeValueForKey:key];
  }
  
  _state = newState;
  
  for (NSString *key in keys) {
    [self didChangeValueForKey:key];
  }
}



@end
