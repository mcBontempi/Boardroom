#import <Foundation/Foundation.h>

typedef void (^voidBlock)();

@interface CheckOperation : NSOperation

- (id)initWithHash:(NSString*)hash room:(NSString *)room falureBlock:(voidBlock)falureBlock;

@end
