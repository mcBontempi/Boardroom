#import "UIImage+PDFMaker.h"

@implementation UIImage (PDFMaker)

+ (id)imageWithPDFURL:(NSURL *)url pageNumber:(NSInteger)pageNumber
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



@end
