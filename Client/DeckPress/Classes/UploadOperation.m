#import "UploadOperation.h"
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
  NSData *_data;
  NSString *_hash;
  NSString *_room;
  AFHTTPClient *_client;
}

- (id)initWithData:(NSData *)data hash:(NSString*)hash room:(NSString *)room;
{
  if (self = [super init]) {
    _state = UploadStateNotStarted;
    _data = data;
    _room = room;
    _hash = hash;
    
    NSString *address;
    
#define LOCAL 0
    
#if LOCAL
    address  = @"http://localhost:80";
#else
    address = @"http://162.13.5.127:80";
#endif
    _client= [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:address]];
    
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
  return YES;
}

- (void)main
{
  
  NSLog(@"data size %d", _data.length);
  
  [self transitionToState:UploadStateRequestQueued
     notifyChangesForKeys:@[@"isExecuting"]];
  
  NSMutableURLRequest *request = [_client multipartFormRequestWithMethod:@"POST" path:@"upload" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
    [formData appendPartWithFileData:_data name:@"myFile" fileName:_hash mimeType:@"image/png"];
  }];
  __weak UploadOperation *weakSelf = self;
  AFHTTPRequestOperation *operation = [_client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject){
    [weakSelf transitionToState:UploadStateRequestSucceeded notifyChangesForKeys:@[@"isExecuting", @"isFinished"]];
    NSLog(@"upload ok!");
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error){
    [weakSelf transitionToState:UploadStateRequestFailed notifyChangesForKeys:@[@"isExecuting", @"isFinished"]];
    NSLog(@"Shit something went wrong!");
    
 //   [[[UIAlertView alloc] initWithTitle:@"connection error" message:@"when uploading" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
    
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
