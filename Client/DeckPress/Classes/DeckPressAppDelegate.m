#import "DeckPressAppDelegate.h"
#import "SwipeViewController.h"
#import "UIImage+PDFMaker.h"
#import "Uploader.h"
#import "PageGenerator.h"
#import "PageData.h"

@interface DeckPressAppDelegate () <SwipeViewControllerDelegate>

@property (nonatomic, strong) PageGenerator *pageGenerator;


@property (nonatomic, strong) NSString *room;
@end

@implementation DeckPressAppDelegate {
    Uploader *_uploader;
}

@synthesize window=_window;


- (NSURL *)docURL
{
    return [[NSBundle mainBundle] URLForResource:@"Bike" withExtension:@"pdf"];
}

- (NSUInteger)pageCount
{
    return [PageGenerator numberOfPagesWithPDFURL:self.docURL];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.room = [self getUUID];
    
    self.pageGenerator = [[PageGenerator alloc] initWithDocURL:self.docURL];
    
    SwipeViewController *swipeViewController = (SwipeViewController *)self.window.rootViewController;
    
    swipeViewController.pageCount = self.pageCount;
    
    swipeViewController.delegate = self;
    swipeViewController.room = self.room;
    
    _uploader = [[Uploader alloc] init];
    
    return YES;
}

- (PageData *)turnedToPage:(NSInteger)page
{
    return [self uploadPage:page];
}


- (PageData *)uploadPage:(NSUInteger)index
{
    PageData *pageData = [self.pageGenerator objectAtIndex:index];
    
    [_uploader uploadPNG:pageData.png hash:pageData.hash room:self.room];

    return pageData;
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
