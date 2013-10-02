#import "CheckOperation.h"
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

@interface CheckOperation ()
@property UploadState state;
@property (readwrite, copy) voidBlock falureBlock;
@end

@implementation CheckOperation
{
  NSString *_hash;
  NSString *_room;
  AFHTTPClient *_client;
}

- (id)initWithHash:(NSString*)hash room:(NSString *)room falureBlock:(voidBlock)falureBlock
{
  if (self = [super init]) {
    _state = UploadStateNotStarted;
    _room = room;
    _hash = hash;
    
    self.falureBlock = falureBlock;
    
    NSString *address;
    
#define LOCAL 0
    
#if LOCAL
    address  = @"http://localhost:8080";
#else
    address = @"http://162.13.5.127:8080";
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
  return NO;
}

- (void)main
{
  
  NSLog(@"Checking");
  
  [self transitionToState:UploadStateRequestQueued
     notifyChangesForKeys:@[@"isExecuting"]];
  
  NSMutableURLRequest *request = [_client requestWithMethod:@"POST" path:@"check" parameters:@{@"filename" : _hash}];
  
  __weak CheckOperation *weakSelf = self;
 
  AFHTTPRequestOperation *operation = [_client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject){
    [weakSelf transitionToState:UploadStateRequestSucceeded notifyChangesForKeys:@[@"isExecuting", @"isFinished"]];
    NSLog(@"check ok!");
    
    NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    
    NSLog(@"responseObject = %@", responseStr);
    
    if ([responseStr isEqualToString:@"Not Found"]) {
      weakSelf.falureBlock();
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error){
    [weakSelf transitionToState:UploadStateRequestFailed notifyChangesForKeys:@[@"isExecuting", @"isFinished"]];
    NSLog(@"Shit something went wrong!");
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
