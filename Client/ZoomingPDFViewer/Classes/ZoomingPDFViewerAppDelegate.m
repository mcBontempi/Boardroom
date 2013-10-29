#import "ZoomingPDFViewerAppDelegate.h"
#import "SwipeViewController.h"
#import "UIImage+PDFMaker.h"
#import "Uploader.h"

@interface ZoomingPDFViewerAppDelegate () <SwipeViewControllerDelegate>

@property (nonatomic, strong) NSArray *imagesForSwipeView;
@end

@implementation ZoomingPDFViewerAppDelegate {
  Uploader *_uploader;
}

@synthesize window=_window;


- (NSArray *)imagesForSwipeView
{
  if(!_imagesForSwipeView) {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"DeckPress" withExtension:@"pdf"];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0 ;i < 6 ; i++) {
      [array addObject: [UIImage imageWithPDFURL:url pageNumber:i+1]];
    }
    
    _imagesForSwipeView =  [array copy];
  }
  return _imagesForSwipeView;
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  SwipeViewController *swipeViewController = (SwipeViewController *)self.window.rootViewController;
  
  swipeViewController.images = [self imagesForSwipeView];
  
  swipeViewController.delegate = self;
  
  _uploader = [[Uploader alloc] init];
  
  [_uploader uploadImage:self.imagesForSwipeView[0] room:@"hello"];
  
  return YES;
}

- (void)turnedToPage:(NSInteger)page
{
  [_uploader uploadImage:self.imagesForSwipeView[page] room:@"hello"];
}



@end
