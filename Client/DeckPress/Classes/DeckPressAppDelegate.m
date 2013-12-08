#import "DeckPressAppDelegate.h"
#import "SwipeViewController.h"
#import "UIImage+PDFMaker.h"
#import "Uploader.h"

@interface DeckPressAppDelegate () <SwipeViewControllerDelegate>

@property (nonatomic, strong) NSArray *imagesForSwipeView;
@property (nonatomic, strong) NSArray *pngsForSwipeView;
@property (nonatomic, strong) NSArray *hashesForSwipeView;


@property (nonatomic, strong) NSString *room;
@end

@implementation DeckPressAppDelegate {
  Uploader *_uploader;
}

@synthesize window=_window;


- (NSArray *)imagesForSwipeView
{
  if(!_imagesForSwipeView) {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Bike" withExtension:@"pdf"];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0 ;i < 11 ; i++) {
      [array addObject: [UIImage imageWithPDFURL:url pageNumber:i+1]];
    }
    
    _imagesForSwipeView =  [array copy];
  }
  return _imagesForSwipeView;
}

- (NSArray *)pngsForSwipeView
{
  if(!_pngsForSwipeView) {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Bike" withExtension:@"pdf"];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0 ;i < 11 ; i++) {
      UIImage *image = [UIImage imageWithPDFURL:url pageNumber:i+1];
      
      NSData *data = UIImagePNGRepresentation(image);
      
      [array addObject:data];
    }
    
    _pngsForSwipeView = [array copy];
    
  }
  return _pngsForSwipeView;
}

- (NSArray *)hashesForSwipeViewx
{
  if(!_hashesForSwipeView) {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Bike" withExtension:@"pdf"];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0 ;i < 11 ; i++) {
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
  self.room = [self getUUID];
  
  
  SwipeViewController *swipeViewController = (SwipeViewController *)self.window.rootViewController;
  swipeViewController.images = [self imagesForSwipeView];
  swipeViewController.delegate = self;
  swipeViewController.room = self.room;
  
  _uploader = [[Uploader alloc] init];
  [_uploader uploadPNG:self.pngsForSwipeView[0] hash:self.hashesForSwipeView[0] room:self.room];
  
  return YES;
}

- (void)turnedToPage:(NSInteger)page
{
  [_uploader uploadPNG:self.pngsForSwipeView[page] hash:self.hashesForSwipeView[page] room:self.room];
  
}


-(NSString *)getUUID
{
  return @"2AC9EC35-7CEE-4313-BA67-EF90E301B241";
  
  
  CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
  NSString * uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
  CFRelease(newUniqueId);
  
  return uuidString;
}






@end
