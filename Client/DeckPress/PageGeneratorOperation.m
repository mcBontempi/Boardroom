//
//  PageGeneratorOperation.m
//  DeckPress
//
//  Created by Daren David Taylor on 12/12/2013.
//
//

#import "PageGeneratorOperation.h"
#import "PageData.h"
#include <CommonCrypto/CommonDigest.h>

typedef NS_ENUM(NSInteger, PageGeneratorState) {
    PageGeneratorStateNotStarted = 0,
    PageGeneratorStateQueued,
    PageGeneratorStateSucceeded,
};

@interface PageGeneratorOperation ()
@property PageGeneratorState state;

@end

@implementation PageGeneratorOperation {
    NSURL *_docURL;
    pageDataBlock _successBlock;
    PageData *_pageData;
    NSUInteger _index;
}

- (id)initWitdocURL:(NSURL *)docURL index:(NSUInteger)index successBlock:(pageDataBlock)successBlock
{
    if (self = [super init]) {
        _state = PageGeneratorStateNotStarted;
        _docURL = docURL;
        
        _successBlock = successBlock;
        
        _index = index;
    }
    return self;
}

- (BOOL)isFinished
{
    return self.state == PageGeneratorStateSucceeded;
}

- (BOOL)isExecuting
{
    return self.state == PageGeneratorStateQueued;
}

- (BOOL)isReady
{
    return self.state == PageGeneratorStateNotStarted;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (void)main
{
    NSLog(@"generating page %d", _index);
    
    [self transitionToState:PageGeneratorStateQueued
       notifyChangesForKeys:@[@"isExecuting"]];
    
    _pageData = [[PageData alloc] init];
    _pageData.index = _index;
    _pageData.image = [self.class imageWithPDFURL:_docURL pageNumber:_index+1];
    _pageData.png = UIImagePNGRepresentation(_pageData.image);
    _pageData.hash = [self.class MD5StringOfData:_pageData.png];
    _pageData.generated = YES;
    
    [self transitionToState:PageGeneratorStateSucceeded notifyChangesForKeys:@[@"isExecuting", @"isFinished"]];
    _successBlock(_pageData);
    
}

- (void)cancel
{
}

- (void)transitionToState:(PageGeneratorState)newState notifyChangesForKeys:(NSArray *)keys
{
    for (NSString *key in keys) {
        [self willChangeValueForKey:key];
    }
    
    _state = newState;
    
    for (NSString *key in keys) {
        [self didChangeValueForKey:key];
    }
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
    CGFloat scale = 0.5;//self.frame.size.width/pageRect.size.width;
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
