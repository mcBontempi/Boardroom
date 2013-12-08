#import <UIKit/UIKit.h>

@interface UIImage (PDFMaker)

+ (id)imageWithPDFURL:(NSURL *)url pageNumber:(NSInteger)pageNumber;
+ (NSInteger)numberOfPagesWithPDFURL:(NSURL *)url;

@end
