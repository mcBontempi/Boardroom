#import "UploadOperation.h"

typedef NS_ENUM(NSInteger, UploadState) {
  UploadStateNotStarted = 0,
  UploadStateRequestQueued,
  UploadStateRequestFailedAwaitingNetworkConnection,
  UploadStateRequestFailedAwaitingRetry,
  UploadStateRequestFailedAwaitingAuthentication,
  UploadStateRequestFailed,
  UploadStateRequestSucceeded,
};

@implementation UploadOperation

- (void)start
{
  
}

@end
