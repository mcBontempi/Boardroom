#import "ZoomingPDFViewerViewController.h"
#import "PDFScrollView.h"
#import <QuartzCore/QuartzCore.h>
#import "Uploader.h"

@interface ZoomingPDFViewerViewController ()
@property (nonatomic) NSInteger page;
@end

@implementation ZoomingPDFViewerViewController {
  PDFScrollView *_currentPDFScrollView;
  Uploader *_uploader;
  NSString *_hash;
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
  _page = page;
  
  // remove the old view
  [_currentPDFScrollView removeFromSuperview];

  // add the new page & guesture recognizers
  _currentPDFScrollView = [[PDFScrollView alloc] initWithFrame:CGRectMake(0,0,568,320)];
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
  NSURL *pdfURL = [[NSBundle mainBundle] URLForResource:@"r8" withExtension:@"pdf"];
  
  CGPDFDocumentRef PDFDocument = CGPDFDocumentCreateWithURL((__bridge CFURLRef)pdfURL);
  CGPDFPageRef PDFPage = CGPDFDocumentGetPage(PDFDocument, page);
  [_currentPDFScrollView setPDFPage:PDFPage];
  CGPDFDocumentRelease(PDFDocument);
  
  [self performSelector:@selector(uploadIfNothingInQueueAtMax) withObject:Nil afterDelay:0.01];
  }

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)uploadIfNothingInQueueAtMax
{
  if (!_uploader.isBusy) {
    [_uploader uploadImage:_currentPDFScrollView.backgroundImageView.image room:@"hello"];
  }
}


@end
