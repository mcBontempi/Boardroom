#import "DeckPressAppDelegate.h"
#import "SwipeViewController.h"

@interface DeckPressAppDelegate ()

@end

@implementation DeckPressAppDelegate
@synthesize window=_window;

- (void)delayedSetDocument:(NSNotification *)notification
{
    SwipeViewController *swipeViewController = (SwipeViewController *)self.window.rootViewController;

    swipeViewController.document = notification;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    [self performSelector:@selector(delayedSetDocument:) withObject:[[Document alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"Bike" withExtension:@"pdf"] room:self.UUID] afterDelay:1.0];
    
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    SwipeViewController *swipeViewController = (SwipeViewController *)self.window.rootViewController;
    swipeViewController.document = [[Document alloc] initWithURL:url room:self.UUID];

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
