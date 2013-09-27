/*
     File: ZoomingPDFViewerViewController.m
 Abstract: ViewController whose view is a PDFScrollView (specified in the MainStoryboard storyboard).
  Version: 2
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2012 Apple Inc. All Rights Reserved.
 
 */

#import "ZoomingPDFViewerViewController.h"
#import "PDFScrollView.h"
#import <QuartzCore/QuartzCore.h>
#import "Uploader.h"
#import "DWFParticleView.h"

@interface ZoomingPDFViewerViewController ()
@property (nonatomic) NSInteger page;
@end

@implementation ZoomingPDFViewerViewController {
  PDFScrollView *_currentPDFScrollView;
  
  Uploader *_uploader;
  
  DWFParticleView *_fireView;
  
  
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
  if (self = [super initWithCoder:aDecoder]) {
    _uploader = [[Uploader alloc] init];
  }
  return self;
}

- (void)setPage:(NSInteger)page
{
  // set the ivar
  
  // remove the old view
  [_currentPDFScrollView removeFromSuperview];

  // add the new page & guesture recognizers
  _currentPDFScrollView = [[PDFScrollView alloc] initWithFrame:self.view.frame];
  UISwipeGestureRecognizer *swipeLeftGuestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
  swipeLeftGuestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
  UISwipeGestureRecognizer *swipeRightGuestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
  swipeRightGuestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
  UITapGestureRecognizer *tapGuestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
  [_currentPDFScrollView addGestureRecognizer:swipeLeftGuestureRecognizer];
  [_currentPDFScrollView addGestureRecognizer:swipeRightGuestureRecognizer];
  [_currentPDFScrollView addGestureRecognizer:tapGuestureRecognizer];
  [self.view addSubview:_currentPDFScrollView];

  // set the current page
  NSURL *pdfURL = [[NSBundle mainBundle] URLForResource:@"IMW" withExtension:@"pdf"];
  CGPDFDocumentRef PDFDocument = CGPDFDocumentCreateWithURL((__bridge CFURLRef)pdfURL);
  CGPDFPageRef PDFPage = CGPDFDocumentGetPage(PDFDocument, page);
  [_currentPDFScrollView setPDFPage:PDFPage];
  CGPDFDocumentRelease(PDFDocument);
  
  _fireView = [[DWFParticleView alloc] initWithFrame:self.view.frame];
  _fireView.backgroundColor = [UIColor clearColor];
  [self.view addSubview:_fireView];

  [_uploader progressivelyUploadView:_currentPDFScrollView room:@"hello"];

  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
     Open the PDF document, extract the first page, and pass the page to the PDF scroll view.
     */
  
  self.page = 1;
}

- (IBAction)swipeLeft:(id)sender
{
  self.page++;
}
- (IBAction)swipeRight:(id)sender
{
  self.page--;
}

- (IBAction)tapped:(id)sender
{
  self.page++;
}




- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [_fireView setEmitterPositionFromTouch: [touches anyObject]];
  
  [self uploadIfNothingInQueueAtMax];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [_fireView setEmitterPositionFromTouch: [touches anyObject]];
  [_fireView setIsEmitting:YES];

  [self uploadIfNothingInQueueAtMax];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [_fireView setIsEmitting:NO];
  

}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [_fireView setIsEmitting:NO];
}

- (void)uploadIfNothingInQueueAtMax
{
  if (!_uploader.isBusy) {
    [_uploader uploadView:self.view room:@"hello"];
  }
}


@end
