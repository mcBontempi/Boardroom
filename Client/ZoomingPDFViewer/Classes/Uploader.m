#import "Uploader.h"
#import "UploadOperation.h"
#import "UploadOperationQueue.h"
#import "ImageMaker.h"
#include <CommonCrypto/CommonDigest.h>

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

- (NSString*)MD5StringOfData:(NSData*)inputData
{
	unsigned char outputData[CC_MD5_DIGEST_LENGTH];
	CC_MD5([inputData bytes], [inputData length], outputData);
	
	NSMutableString* hashStr = [NSMutableString string];
	int i = 0;
	for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i)
		[hashStr appendFormat:@"%02x", outputData[i]];
	
	return hashStr;
}

- (void)uploadImage:(UIImage *)image room:(NSString *)room
{
  [_queue reset];
  
  NSData *data = UIImagePNGRepresentation(image);
  
  NSString *hash = [self MD5StringOfData:data];
  
  UploadOperation *uploadOperation = [[UploadOperation alloc] initWithData:data room:room];
  [_queue addOperation:uploadOperation];
}

- (BOOL)isBusy
{
  return _queue.isBusy;
}

@end
