#import "ZoomingPDFViewerAppDelegate.h"
#import "SwipeViewController.h"
#import "UIImage+PDFMaker.h"
#import "Uploader.h"

@interface ZoomingPDFViewerAppDelegate () <SwipeViewControllerDelegate>

@property (nonatomic, strong) NSArray *imagesForSwipeView;
@property (nonatomic, strong) NSArray *pngsForSwipeView;
@property (nonatomic, strong) NSArray *hashesForSwipeView;
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

- (NSArray *)pngsForSwipeView
{
  if(!_pngsForSwipeView) {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"DeckPress" withExtension:@"pdf"];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0 ;i < 6 ; i++) {
      UIImage *image = [UIImage imageWithPDFURL:url pageNumber:i+1];
      
      NSData *data = UIImagePNGRepresentation(image);
      
      [array addObject:data];
    }
    
    _pngsForSwipeView = [array copy];
    
  }
  return _pngsForSwipeView;
}

- (NSArray *)hashesForSwipeView
{
  if(!_hashesForSwipeView) {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"DeckPress" withExtension:@"pdf"];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0 ;i < 6 ; i++) {
      UIImage *image = [UIImage imageWithPDFURL:url pageNumber:i+1];
      
      NSData *data = UIImagePNGRepresentation(image);
      
      NSString *hash = [Uploader MD5StringOfData:data];
      
      [array addObject:hash];
    }
    
    _hashesForSwipeView = [array copy];
    
  }
  return _hashesForSwipeView;
}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  SwipeViewController *swipeViewController = (SwipeViewController *)self.window.rootViewController;
  
  swipeViewController.images = [self imagesForSwipeView];
  
  swipeViewController.delegate = self;
  
  _uploader = [[Uploader alloc] init];
  
  
  
  [_uploader uploadPNG:self.pngsForSwipeView[0] hash:self.hashesForSwipeView[0] room:@"hello"];
  
  return YES;
}

- (void)turnedToPage:(NSInteger)page
{
 // [_uploader uploadImage:self.imagesForSwipeView[page] room:@"hello"];
  
  
  [_uploader uploadPNG:self.pngsForSwipeView[page] hash:self.hashesForSwipeView[page] room:@"hello"];
  
}



@end
