#import "DeckPressAppDelegate.h"
#import "SwipeViewController.h"

@interface DeckPressAppDelegate ()

@end

@implementation DeckPressAppDelegate
@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    SwipeViewController *swipeViewController = (SwipeViewController *)self.window.rootViewController;
    swipeViewController.document = [[Document alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"Bike" withExtension:@"pdf"] room:self.UUID];
    
    
    return YES;
}

-(NSString *)UUID
{
    return @"2AC9EC35-7CEE-4313-BA67-EF90E301B241";
    
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    NSString * uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    CFRelease(newUniqueId);
    
    return uuidString;
}

@end
