#import "SwipeViewController.h"
#import <MessageUI/MessageUI.h>
#import "PageData.h"

@interface SwipeViewController () <UIScrollViewDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation SwipeViewController {
    NSInteger _pageNumber;
    UIView *_slideContainerView;
}

- (void)viewDidLoad
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageChangedNotificationHandler:) name:@"pageChangedNotification" object:nil];
    
    [super viewDidLoad];
    
    //debug
    //  [self shareRoom];
    
    [self sizeScrollViewContentToPageCount];
    
    self.scrollView.delegate = self;
    
    [self.document turnedToPage:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self slideCheck];
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
        imageView.backgroundColor = [UIColor redColor];
        imageView.frame = CGRectMake(i * pageWidth, 0, pageWidth, pageHeight);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [_slideContainerView addSubview:imageView];
    }
}

- (void)insertPage:(PageData *)pageData
{
    
    
    
  //  if (![_hashToImageDictionary objectForKey:pageData.hash]) {
        CGFloat pageWidth = self.scrollView.frame.size.width;
        CGFloat pageHeight = self.scrollView.frame.size.height;
        
    
   //     [_hashToImageDictionary setObject:imageView forKey:pageData.hash];
    
    
    UIImageView *imageView = _slideContainerView.subviews[pageData.index];
    
    imageView.image = [pageData.image copy];
    
        NSLog(@"updated uiimageview");
        
        [self.scrollView setNeedsDisplay];
 //   }
    
    // do ther actual upload / check if we are on the page
    if(pageData.index == self.currentPage) {
        [self.document turnedToPageKnowingImageCorrect:pageData.index];
    }
    
    
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


// checks to see if we have a nice collection of prerendered slides around our current slide
- (void)slideCheck
{
    for (NSUInteger i = 0 ; i < self.document.pageCount ; i++) {
   //     [self.document turnedToPage:i];
    }
}

- (void)shareRoom
{
    NSString *emailTitle = @"Invitation to join a DeckPress presentation sharing session";
    NSString *messageBody = [NSString stringWithFormat:@"http://162.13.5.127/serve?room=%@", @"needs room"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:nil];
    
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}




@end
