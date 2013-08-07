#import <UIKit/UIKit.h>
#import "Slide.h"
#import "EditSlideCellDelegate.h"

@interface EditSlideCell : UICollectionViewCell

@property (nonatomic, strong) Slide *slide;
@property (nonatomic, weak) id<EditSlideCellDelegate> delegate;

@end
