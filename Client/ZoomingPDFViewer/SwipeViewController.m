#import "SwipeViewController.h"

@interface SwipeViewController () <UIScrollViewDelegate>
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
  
  [self loadImagesOntoScrollView];
  
  self.scrollView.delegate = self;
  
}

- (void)loadImagesOntoScrollView
{
  CGFloat pageWidth = self.scrollView.frame.size.width;
  CGFloat pageHeight = self.scrollView.frame.size.height;
  self.scrollView.contentSize = CGSizeMake(pageWidth*6, pageHeight);
  
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




@end
