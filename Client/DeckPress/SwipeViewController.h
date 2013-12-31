#import <UIKit/UIKit.h>
#import "Document.h"

@interface SwipeViewController : UIViewController

@property (nonatomic, strong) Document *document;

- (NSUInteger)currentPage;

@end
