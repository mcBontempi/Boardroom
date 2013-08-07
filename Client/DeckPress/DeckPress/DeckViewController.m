#import "DeckViewController.h"
#import "EditSlideCell.h"
#import "EditSlideCellDelegate.h"

@interface DeckViewController () <EditSlideCellDelegate>

@end

@implementation DeckViewController

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return self.deck.slides.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  EditSlideCell *editSlideCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EditSlideCellIdentifier" forIndexPath:indexPath];
 
  editSlideCell.delegate = self;
  Slide *slide = self.deck.slides[indexPath.row];
  editSlideCell.slide = slide;
  
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


@end
