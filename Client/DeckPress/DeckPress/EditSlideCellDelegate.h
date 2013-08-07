#import <Foundation/Foundation.h>
#import "Slide.h"

@protocol EditSlideCellDelegate <NSObject>

- (void)slideChanged:(Slide *)slide;

@end
