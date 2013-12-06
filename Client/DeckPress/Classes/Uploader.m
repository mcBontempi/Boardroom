#import "Uploader.h"
#import "UploadOperation.h"
#import "UploadOperationQueue.h"
#include <CommonCrypto/CommonDigest.h>
#import "CheckOperation.h"

// uploader can only check for / upload one image at a time

@implementation Uploader
{
  UploadOperationQueue *_queue;
  
  NSData *_data;
  NSString *_hash;
}

- (id) init
{
  if (self = [super init]) {
    _queue = [[UploadOperationQueue alloc] init];
  }
  return self;
}

+ (NSString*)MD5StringOfData:(NSData*)inputData
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
  
 _data = UIImagePNGRepresentation(image);
 _hash = [Uploader MD5StringOfData:_data];
  
  NSLog(@"hash = %@", _hash);
  
  CheckOperation *checkOperation = [[CheckOperation alloc] initWithHash:_hash room:room falureBlock: ^{
    UploadOperation *uploadOperation = [[UploadOperation alloc] initWithData:_data hash:_hash room:room];
    [_queue addOperation:uploadOperation];} ];
  [_queue addOperation:checkOperation];


}


- (void)uploadPNG:(NSData *)data hash:(NSString *)hash room:(NSString *)room
{
 // [_queue reset];
  
  _data = data;
  _hash = hash;
  
  NSLog(@"hash = %@", _hash);
  
   CheckOperation *checkOperation = [[CheckOperation alloc] initWithHash:_hash room:room falureBlock: ^{
   UploadOperation *uploadOperation = [[UploadOperation alloc] initWithData:_data hash:_hash room:room];
   [_queue addOperation:uploadOperation];} ];
   [_queue addOperation:checkOperation];
  
  
}

- (BOOL)isBusy
{
  return _queue.isBusy;
}

@end
