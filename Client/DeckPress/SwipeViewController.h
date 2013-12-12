#import <UIKit/UIKit.h>
#import "SwipeViewControllerDelegate.h"

@interface SwipeViewController : UIViewController

@property (nonatomic) NSUInteger pageCount;
@property (nonatomic, weak) id<SwipeViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *room;

- (void)showPage:(NSUInteger)index;

@end
