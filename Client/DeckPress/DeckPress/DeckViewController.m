#import "DeckViewController.h"
#import "EditSlideCell.h"
#import "EditSlideCellDelegate.h"

@interface DeckViewController () <EditSlideCellDelegate>

@end

@implementation DeckViewController
{
  NSInteger _pageNum;
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  
  UIScrollView *scrollView = self.collectionView;
  scrollView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  [self uploadSlide:0];
}

- (void)uploadSlide:(NSUInteger)index
{
  EditSlideCell *editSlideCell = (EditSlideCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
  
  [self.uploader uploadView:editSlideCell.contentView];

}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return self.deck.slides.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  EditSlideCell *editSlideCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EditSlideCellIdentifier" forIndexPath:indexPath];
 
  editSlideCell.delegate = self;
  editSlideCell.slide = self.deck.slides[indexPath.row];
  
  return editSlideCell;
}

#pragma mark - LXReorderableCollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
  [self.deck moveFrom:fromIndexPath.item to:toIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
  return YES;
}

#pragma mark - EditSlideCellDelegate methods

- (void)slideChanged:(Slide *)slide
{
  
}

- (void)viewChanged:(UIView *)view
{
  [_uploader uploadView:view];
}





- (void)scrollViewDidScroll:(UIScrollView *)sender {
  
  UIScrollView *scrollView = self.collectionView;
  
  int pageNum = (int)((scrollView.contentOffset.x+(scrollView.frame.size.width/2) ) / scrollView.frame.size.width);
 
  NSLog(@"pageNum %d", pageNum);
  
  if(pageNum != _pageNum) {
    _pageNum = pageNum;

    [self uploadSlide:_pageNum];
  }
  
  
}


@end
