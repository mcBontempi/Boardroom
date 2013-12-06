#import "SwipeViewController.h"
#import <MessageUI/MessageUI.h>

@interface SwipeViewController () <UIScrollViewDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation SwipeViewController {
  NSInteger _pageNumber;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self shareRoom];
  
  [self loadImagesOntoScrollView];
  
  self.scrollView.delegate = self;
  
}

- (void)loadImagesOntoScrollView
{
  CGFloat pageWidth = self.scrollView.frame.size.width;
  CGFloat pageHeight = self.scrollView.frame.size.height;
  self.scrollView.contentSize = CGSizeMake(pageWidth*11, pageHeight);
  
  [self.images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(idx * pageWidth, 0, pageWidth, pageHeight);
    [self.scrollView addSubview:imageView];
    
  }];
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
  
  NSInteger pageNumber = (int)((self.scrollView.contentOffset.x+(self.scrollView.frame.size.width/2) ) / self.scrollView.frame.size.width);
  if(pageNumber != _pageNumber) {
    _pageNumber = pageNumber;
    if(pageNumber < self.images.count) {
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
