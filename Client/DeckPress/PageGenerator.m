//
//  PageGenerator.m
//  DeckPress
//
//  Created by Daren David Taylor on 08/12/2013.
//
//

#import "PageGenerator.h"
#import "pageData.h"
#import "UIImage+PDFMaker.h"
#include <CommonCrypto/CommonDigest.h>

@implementation PageGenerator {
    NSMutableArray *_array;
    NSURL *_docURL;
}

- (id)init
{
    assert(0);
    return nil;
}

- (id)initWithDocURL:(NSURL *)docURL
{
    if (self = [super init]) {
        
        _docURL = docURL;
        _array = [[NSMutableArray alloc] init];
        
        for (NSUInteger i = 0 ; i < [self.class numberOfPagesWithPDFURL:docURL] ; i++) {
            [_array addObject:[[PageData alloc] init]];
        }
    }
    
    return self;
}

- (id)objectAtIndex:(NSUInteger)index
{
    PageData *pageData = _array[index];
    if (!pageData.generated) {
        pageData.image = [self.class imageWithPDFURL:_docURL pageNumber:index+1];
        pageData.png = UIImagePNGRepresentation(pageData.image);
        pageData.hash = [PageGenerator MD5StringOfData:pageData.png];
        
        pageData.generated = YES;
    }
    
    return pageData;
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




+ (UIImage *)imageWithPDFURL:(NSURL *)url pageNumber:(NSInteger)pageNumber
{
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL((__bridge CFURLRef)url);
    CGPDFPageRef pdf = CGPDFDocumentGetPage(document, pageNumber);
    
    CGPDFPageRetain(pdf);
    
    // Determine the size of the PDF page.
    CGRect pageRect = CGPDFPageGetBoxRect(pdf, kCGPDFMediaBox);
    CGFloat scale = 1.0;//self.frame.size.width/pageRect.size.width;
    pageRect.size = CGSizeMake(pageRect.size.width*scale, pageRect.size.height*scale);
    
    UIGraphicsBeginImageContext(pageRect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // First fill the background with white.
    CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
    CGContextFillRect(context,pageRect);
    
    CGContextSaveGState(context);
    // Flip the context so that the PDF page is rendered right side up.
    CGContextTranslateCTM(context, 0.0, pageRect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Scale the context so that the PDF page is rendered at the correct size for the zoom level.
    CGContextScaleCTM(context, scale,scale);
    CGContextDrawPDFPage(context, pdf);
    CGContextRestoreGState(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGPDFPageRelease(pdf);
    
    CGPDFDocumentRelease(document);
    
    return image;
}

+ (NSInteger)numberOfPagesWithPDFURL:(NSURL *)url
{
    NSUInteger pageCount;
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL((__bridge CFURLRef)url);
    pageCount = CGPDFDocumentGetNumberOfPages(document);
    CGPDFDocumentRelease(document);
    
    return pageCount;
}






@end