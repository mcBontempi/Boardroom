#import "SwipeViewController.h"
#import <MessageUI/MessageUI.h>
#import "PageData.h"
#import "DeckPressAppDelegate.h"

@interface SwipeViewController () <UIScrollViewDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIToolbar *topToolBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation SwipeViewController {
    NSInteger _pageNumber;
    UIView *_slideContainerView;
    BOOL _toolbarVisible;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageChangedNotificationHandler:) name:@"pageChangedNotification" object:nil];
  
  _toolbarVisible = YES;
  
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  
}

- (void)setDocument:(Document *)document
{
    _document = document;
 
    [_slideContainerView removeFromSuperview];
    
    [self sizeScrollViewContentToPageCount];
    
    self.scrollView.contentOffset = CGPointMake(0,0);
    
    self.scrollView.delegate = self;
    
    [self.document turnedToPage:0];
}

- (void)pageChangedNotificationHandler:(NSNotification *)notification
{
    PageData *pageData = (PageData*)notification.object;
    
    [self performSelectorOnMainThread:@selector(insertPage:) withObject:pageData waitUntilDone:NO];
}

- (void)sizeScrollViewContentToPageCount
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGFloat pageHeight = self.scrollView.frame.size.height;
    
    self.scrollView.contentSize = CGSizeMake(pageWidth*self.document.pageCount, pageHeight);
    
    _slideContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pageWidth*self.document.pageCount, pageHeight)];
    
    [self.scrollView addSubview:_slideContainerView];
    
    for (NSUInteger i = 0 ; i < self.document.pageCount ; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:nil];
        imageView.frame = CGRectMake(i * pageWidth, 0, pageWidth, pageHeight);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [_slideContainerView addSubview:imageView];
    }
}

- (void)insertPage:(PageData *)pageData
{
    UIImageView *imageView = _slideContainerView.subviews[pageData.index];
    
    imageView.alpha = 0.0;
    
    imageView.image = [pageData.image copy];
    
    NSLog(@"updated uiimageview");
    
    [self.scrollView setNeedsDisplay];
    
    [UIView animateWithDuration:0.2 animations:^{imageView.alpha = 1.0; }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    NSInteger pageNumber = (int)((self.scrollView.contentOffset.x+(self.scrollView.frame.size.width/2) ) / self.scrollView.frame.size.width);
    if(pageNumber != _pageNumber) {
        _pageNumber = pageNumber;
        if(pageNumber < self.document.pageCount) {
            [self.document turnedToPage:pageNumber];
        }
    }
}

- (NSUInteger)currentPage
{
    return (int)((self.scrollView.contentOffset.x+(self.scrollView.frame.size.width/2) ) / self.scrollView.frame.size.width);
}

- (IBAction)sendPressed:(id)sender {
  
  DeckPressAppDelegate *deckPressAppDelegate = [[UIApplication sharedApplication] delegate];
  
 // NSString *shareString = @"Invitation to join a DeckPress presentation sharing session";
 // UIImage *shareImage = [UIImage imageNamed:@"icon.png"];
  NSURL *shareUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://162.13.5.127/serve?room=%@", [deckPressAppDelegate UUID]]];
  
  NSArray *activityItems = [NSArray arrayWithObjects: shareUrl, nil];
  
  UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
  activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  
  [self presentViewController:activityViewController animated:YES completion:nil];
}

- (IBAction)uploadTapped:(id)sender
{
  [self.document uploadAll];
}

- (IBAction)screenTapped:(id)sender
{
  
  
  [UIView animateWithDuration:0.5 animations:^{   self.topToolBar.alpha = self.toolBar.alpha = _toolbarVisible ? 0.0 : 1.0;
  }];
  [[UIApplication sharedApplication] setStatusBarHidden:_toolbarVisible withAnimation:UIStatusBarAnimationFade];
  
  _toolbarVisible = !_toolbarVisible;
  
}

@end
