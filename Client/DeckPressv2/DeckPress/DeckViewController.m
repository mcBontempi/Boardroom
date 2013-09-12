#import "DeckViewController.h"
#import "EditSlideCell.h"
#import "EditSlideCellDelegate.h"
#import <NeoveraColorPicker/NEOColorPickerViewController.h>

@interface DeckViewController () <EditSlideCellDelegate, NEOColorPickerViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation DeckViewController
{
  NSInteger _pageNum;
  BOOL initialPageSent;
  
  
  BOOL swipedUp;
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
  
  if (!initialPageSent) {
    [self progressivelyUploadCellAtIndex:0];
    initialPageSent = YES;
  }
}

- (void)progressivelyUploadCurrentCell
{
  [self progressivelyUploadCellAtIndex:_pageNum];
}

- (void)progressivelyUploadCellAtIndex:(NSUInteger)index
{
  EditSlideCell *editSlideCell = (EditSlideCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
  
  assert(editSlideCell);
  
  [self.uploader progressivelyUploadView:editSlideCell.contentView];
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
  
  NSLog(@"in cellforitem %@", editSlideCell.slide.text);
  
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
  //[self.delegate saveDeck];
  
  //[_uploader progressivelyUploadView:view];
  
      [self performSelector:@selector(progressivelyUploadCurrentCell) withObject:Nil afterDelay:0.1];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)sender {
  
  UIScrollView *scrollView = self.collectionView;
  int pageNum = (int)((scrollView.contentOffset.x+(scrollView.frame.size.width/2) ) / scrollView.frame.size.width);
  if(pageNum != _pageNum) {
    _pageNum = pageNum;
    
    [self progressivelyUploadCellAtIndex:_pageNum];
  }
}

#pragma mark - actions
- (IBAction)swipeUp:(id)sender
{
  [self showImagePicker];
  
  // swipedUp = YES;
  // [self showColorPicker];
}
- (IBAction)swipeDown:(id)sender
{
  swipedUp = NO;
  
  [self showColorPicker];
}

- (void)showImagePicker
{
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.delegate = self;
  picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
  
  [picker setMediaTypes:[NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil]];
  
  [self presentViewController:picker animated:YES completion:nil];
}


- (void)showColorPicker
{
  NEOColorPickerViewController *controller = [[NEOColorPickerViewController alloc] init];
  controller.delegate = self;
  controller.selectedColor = [UIColor redColor];
  controller.title = @"My dialog title";
  UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:controller];
  [self presentViewController:navVC animated:YES completion:nil];
  
}

#pragma mark - NEOColorPickerViewControllerDelegate methods

- (void) colorPickerViewController:(NEOColorPickerBaseViewController *)controller didSelectColor:(UIColor *)color {
  
  [controller dismissViewControllerAnimated:NO completion:^{Slide *slide = self.deck.slides[_pageNum];
    
    if(swipedUp) {
      slide.backgroundColor = color;
    }
    else {
      slide.textColor = color;
    }
    [self.collectionView reloadData];
    [self.delegate saveDeck];
    
    [self performSelector:@selector(progressivelyUploadCurrentCell) withObject:Nil afterDelay:0.5];
    
  }];
  
}

- (void) colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller {
  [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  [picker dismissViewControllerAnimated:YES completion:^{
    UIImage* image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    Slide *slide = self.deck.slides[_pageNum];
    
    slide.image = image;

    [self.collectionView reloadData];
    
    [self performSelector:@selector(progressivelyUploadCurrentCell) withObject:Nil afterDelay:0.5];
    
    [self.delegate saveDeck];
  }];
}

@end
