#import <UIKit/UIKit.h>
#import "SwipeViewControllerDelegate.h"

@interface SwipeViewController : UIViewController

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, weak) id<SwipeViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *room;

@end
