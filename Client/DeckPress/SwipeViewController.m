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
    [super viewDidLoad];
    
    //debug
    //  [self shareRoom];
    
    [self sizeScrollViewContentToPageCount];
    
    _hashToImageDictionary = [[NSMutableDictionary alloc] init];
    
    self.scrollView.delegate = self;
    
}

- (void)showPage:(NSUInteger)index
{
    PageData *pageData = [self.delegate turnedToPage:index];
    
    [self insertPage:pageData atIndex:index];
}

- (void)sizeScrollViewContentToPageCount
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGFloat pageHeight = self.scrollView.frame.size.height;
    
    self.scrollView.contentSize = CGSizeMake(pageWidth*self.pageCount, pageHeight);
}


- (void)insertPage:(PageData *)pageData atIndex:(NSUInteger)index
{
    if (![_hashToImageDictionary objectForKey:pageData.hash]) {
        
        
        CGFloat pageWidth = self.scrollView.frame.size.width;
        CGFloat pageHeight = self.scrollView.frame.size.height;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:pageData.image];
        
        
        [_hashToImageDictionary setObject:imageView forKey:pageData.hash];
        
        
        imageView.frame = CGRectMake(index * pageWidth, 0, pageWidth, pageHeight);
        [self.scrollView addSubview:imageView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    NSInteger pageNumber = (int)((self.scrollView.contentOffset.x+(self.scrollView.frame.size.width/2) ) / self.scrollView.frame.size.width);
    if(pageNumber != _pageNumber) {
        _pageNumber = pageNumber;
        if(pageNumber < self.pageCount) {
            PageData *pageData = [self.delegate turnedToPage:pageNumber];
            
            [self insertPage:pageData atIndex:pageNumber];
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
