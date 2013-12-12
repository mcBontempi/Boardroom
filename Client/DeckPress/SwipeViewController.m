#import "SwipeViewController.h"
#import <MessageUI/MessageUI.h>

@interface SwipeViewController () <UIScrollViewDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation SwipeViewController {
    NSInteger _pageNumber;
    NSMutableDictionary *_hashToImageDictionary;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self showPage:0];
}

- (void)viewDidLoad
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageChangedNotificationHandler:) name:@"pageChangedNotification" object:nil];
    
    [super viewDidLoad];
    
    //debug
    //  [self shareRoom];
    
    [self sizeScrollViewContentToPageCount];
    
    _hashToImageDictionary = [[NSMutableDictionary alloc] init];
    
    self.scrollView.delegate = self;
    
}

- (void)pageChangedNotificationHandler:(NSNotification *)notification
{
    PageData *pageData = (PageData*)notification.object;

//    [self performSelectorOnMainThread:@selector(insertPage:) withObject:pageData];

    [self performSelectorOnMainThread:@selector(insertPage:) withObject:pageData waitUntilDone:NO];
}

- (void)showPage:(NSUInteger)index
{
    [self.delegate turnedToPage:index];
}

- (void)sizeScrollViewContentToPageCount
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGFloat pageHeight = self.scrollView.frame.size.height;
    
    self.scrollView.contentSize = CGSizeMake(pageWidth*self.pageCount, pageHeight);
}


- (void)insertPage:(PageData *)pageData
{
    if (![_hashToImageDictionary objectForKey:pageData.hash]) {
        
        
        CGFloat pageWidth = self.scrollView.frame.size.width;
        CGFloat pageHeight = self.scrollView.frame.size.height;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:pageData.image];
        
        [_hashToImageDictionary setObject:imageView forKey:pageData.hash];
        
        imageView.frame = CGRectMake(pageData.index * pageWidth, 0, pageWidth, pageHeight);
        [self.scrollView addSubview:imageView];
        
        NSLog(@"updated uiimageview");
        
        [self.scrollView setNeedsDisplay];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    NSInteger pageNumber = (int)((self.scrollView.contentOffset.x+(self.scrollView.frame.size.width/2) ) / self.scrollView.frame.size.width);
    if(pageNumber != _pageNumber) {
        _pageNumber = pageNumber;
        if(pageNumber < self.pageCount) {
          [self.delegate turnedToPage:pageNumber];
            }
    }
}

- (void)shareRoom
{
    NSString *emailTitle = @"Invitation to join a DeckPress presentation sharing session";
    NSString *messageBody = [NSString stringWithFormat:@"http://162.13.5.127/serve?room=%@", self.room];
    
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
