#import "DeckPressAppDelegate.h"
#import "SwipeViewController.h"
#import "Uploader.h"
#import "PageData.h"
#import "PageGeneratorOperation.h"

@interface DeckPressAppDelegate () <SwipeViewControllerDelegate>
@property (nonatomic, strong) NSString *room;
@end

@implementation DeckPressAppDelegate {
    Uploader *_uploader;
}

@synthesize window=_window;


- (NSURL *)docURL
{
    return [[NSBundle mainBundle] URLForResource:@"Alaska" withExtension:@"pdf"];
}

- (NSUInteger)pageCount
{
    return [PageGeneratorOperation numberOfPagesWithPDFURL:self.docURL];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.room = [self getUUID];
    
    SwipeViewController *swipeViewController = (SwipeViewController *)self.window.rootViewController;
    
    swipeViewController.pageCount = self.pageCount;
    
    swipeViewController.delegate = self;
    swipeViewController.room = self.room;
    
    _uploader = [[Uploader alloc] init];
    
    return YES;
}

- (void)turnedToPage:(NSInteger)page
{
    [self uploadPage:page];
}


- (void)uploadPage:(NSUInteger)index
{
    [_uploader makePageDataForURL:self.docURL index:index room:self.room];
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
