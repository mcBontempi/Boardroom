//
//  PresentationViewController.m
//  DeckPress
//
//  Created by Daren taylor on 20/06/2013.
//  Copyright (c) 2013 Daren taylor. All rights reserved.
//

#import "PresentationViewController.h"
#import <AFNetworking/AFHTTPClient.h>
#import <AFNetworking/AFHTTPRequestOperation.h>
#import <QuartzCore/QuartzCore.h>
#import "CNLayoutConstraintBuilder.h"
#import "LXReorderableCollectionViewFlowLayout.h"
#import "PlayingCardCell.h"
#import "Slide.h"
#import "EditSlideCell.h"


@implementation PresentationViewController{
  
  __weak IBOutlet UIScrollView *_scrollView;
  
  __weak IBOutlet UICollectionView *_collectionView;
  __weak IBOutlet UICollectionView *_editCollectionView;
  UIView *_currentView;
  
  __weak IBOutlet UICollectionViewFlowLayout *_flowLayout;
  NSTimer *_timer;
  AFHTTPClient *_client;
  
  NSInteger _changeCount;
  BOOL _uploading;
  
  NSInteger _pageNum;
  
  
  double _quality;
  
  NSMutableArray *_slideDeck;
  
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)refreshScrollViewSlides
{
  [self.deck.slides enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    Slide *slide =  self.deck.slides[idx];
    UIView *slideView = [[UIView alloc] initWithFrame:CGRectMake(0,0,310,174)];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0,0,310,174)];
    textView.backgroundColor = [UIColor greenColor];
    textView.text = slide.text;
    textView.font = [UIFont fontWithName:@"Helvetica" size:50];
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.scrollEnabled = NO;
    [slideView addSubview:textView];
    [_scrollView addSubview:slideView];
  }];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _changeCount = 1;
  _uploading = NO;
  _pageNum = 0;
  
  _quality = 0.2;
  
  _scrollView.pagingEnabled = YES;
  _scrollView.delegate = self;
  
  [self refreshScrollViewSlides];
  
  _currentView = [_scrollView subviews][0];
  
  NSString *address;
  
#if LOCAL
  address  = @"http://localhost:8080";
#else
  address = @"http://162.13.5.127:8080";
#endif
  
  _client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:address]];
  
  
  
  [self tryUpload];
}

- (void)tryUpload
{
  if (!_uploading && _changeCount) {
    
    
    _uploading = YES;
    _changeCount = 0;
    
    
    [self sendScreenshot];
    
    //   NSLog(@"a - send quality %f - page %d" , _quality, _pageNum);
  } else if(!_uploading && _quality <2.0 && !_changeCount) {
    _uploading = YES;
    if(_quality == 0.2) _quality = 1.0;
    else if(_quality == 1.0) _quality = 2.0;
    
    [self sendScreenshot];
    
    //    NSLog(@"b - send quality %f - page %d" , _quality, _pageNum);
  }
  
  
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  _scrollView.frame = CGRectMake(0,0,320,174);
  
  CGFloat padding = 5;
  
  [_scrollView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
    CGRect rect = view.frame;
    rect.origin.y = padding;
    rect.origin.x = (idx*320) + padding;
    rect.size.width = 320 - (padding *2);
    rect.size.height = 174 - (padding *2);
    view.frame = rect;
    
    
    [self recursivelySetTextDelegate:view];
    
  }];
  _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count*320, 174);
  
  
}


- (void)logSubviews:(UIView *)view
{
  [view.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
    
    //  NSLog(@">>");
    //  NSLog(@"%@: %@", NSStringFromClass(subview.class),  NSStringFromCGRect(subview.frame));
    
    [self logSubviews:subview];
    
    //  NSLog(@"<<");
  }];
}



- (void)recursivelySetTextDelegate:(UIView *)view
{
  if(view.class == [UITextView class]) {
    [((UITextView *)view) setDelegate:self];
  } else
    
    [view.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
      
      [self recursivelySetTextDelegate:subview];
    }];
}




- (void)scrollViewDidScroll:(UIScrollView *)sender {
  int pageNum = (int)((_scrollView.contentOffset.x+(_scrollView.frame.size.width/2) ) / _scrollView.frame.size.width);
  
  
  if(pageNum != _pageNum) {
    
    //   NSLog(@"%d", pageNum);
    _pageNum = pageNum;
    [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:_pageNum inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    _currentView = _scrollView.subviews[pageNum];
    
    _changeCount ++;
    _quality = 0.2;
    [self tryUpload];
  }
  
  
}




- (void)sendScreenshot
{
  //  NSLog(@"start");
  UIImage *image = [self captureScreen:_currentView];
  
  if(_collectionView.indexPathsForSelectedItems.count) {
    NSIndexPath *indexPath = _collectionView.indexPathsForSelectedItems[0];
    
  //  Slide *slide = self.deck.slides[indexPath.row];
 //compatability   slide.cachedImage = image;
    
    PlayingCardCell *cell = (PlayingCardCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    cell.playingCardImageView.image = image;
    
    //  [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
  }
  NSData *data = UIImagePNGRepresentation(image);
  
  // NSLog(@"image size %d", data.length);
  
  //  NSLog(@"end");
  
  //  NSLog(@"height = %f", image.size.height);
  
  NSMutableURLRequest *request = [_client multipartFormRequestWithMethod:@"POST" path:@"upload" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
    [formData appendPartWithFileData:data name:@"myFile" fileName:@"temp2.png" mimeType:@"image/png"];
  }];
  
  __weak id weakSelf = self;
  AFHTTPRequestOperation *operation = [_client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject){
    //   NSString *response = [operation responseString];
    //     NSLog(@"response: [%@]",response);
    //  NSLog(@"complete");
    
    _uploading = NO;
    
    [weakSelf tryUpload];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error){
    // NSString *response = [operation responseString];
    //   NSLog(@"response: [%@]",response);
    
    //   NSLog(@"error");
    
    _uploading = NO;
    [weakSelf tryUpload];
  }];
  
  // NSLog(@"send");
  
  [_client enqueueHTTPRequestOperation:operation];
  
}

- (UIView *)zoom:(CGFloat)zoom view:(UIView *)view
{
  if(view) {
    if([view.class isSubclassOfClass:[UIImageView class]]) {
      UIImageView *srcImageView = (UIImageView *)view;
      UIImageView *retImageView =  [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.origin.x * zoom, view.frame.origin.y *zoom, view.frame.size.width*zoom, view.frame.size.height*zoom)];
      
      retImageView.image = srcImageView.image;
      return retImageView;
    }
    else if([view.class isSubclassOfClass:[UITextView class]]) {
      UITextView *srcTextView = (UITextView *)view;
      UITextView *retTextView =  [[UITextView alloc] initWithFrame:CGRectMake(view.frame.origin.x * zoom, view.frame.origin.y *zoom, view.frame.size.width*zoom, view.frame.size.height*zoom)];
      retTextView.text = srcTextView.text;
      retTextView.font = [UIFont fontWithName:srcTextView.font.fontName size:srcTextView.font.pointSize*zoom];
      retTextView.textColor = srcTextView.textColor;
      retTextView.backgroundColor = srcTextView.backgroundColor;
      retTextView.textAlignment = srcTextView.textAlignment;
      return retTextView;
    }
    else if([view.class isSubclassOfClass:[UIView class]]) {
      UIView *srcView = (UIView *)view;
      UIView *retView =  [[UIView alloc] initWithFrame:CGRectMake(view.frame.origin.x * zoom, view.frame.origin.y *zoom, view.frame.size.width*zoom, view.frame.size.height*zoom)];
      retView.backgroundColor = srcView.backgroundColor;
      [view.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        [retView addSubview:[self zoom:zoom view:subview]];
      }];
      
      return retView;
    }
  }
  return nil;
}

-(UIImage*)captureScreen:(UIView*) viewToCapture
{
  UIView *duplicatedView = [self zoom:2 view:viewToCapture];
  
  [self logSubviews:duplicatedView];
  
  UIGraphicsBeginImageContextWithOptions(duplicatedView.bounds.size,NO, _quality);
  
  [duplicatedView layoutSubviews];
  
  [duplicatedView.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  return viewImage;
}


- (void)delayedTextChange
{
  
  _changeCount ++;
  _quality = 2.0;
  [self tryUpload];
}
- (void)textViewDidChange:(UITextView *)textView
{
  [self performSelector:@selector(delayedTextChange) withObject:nil afterDelay:0.1];
}

#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  if (_collectionView == collectionView) {
    [_editCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
  }
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)theCollectionView numberOfItemsInSection:(NSInteger)theSectionIndex {
  return self.deck.slides.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  if(collectionView == _collectionView) {
    PlayingCardCell *playingCardCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCardCell" forIndexPath:indexPath];
    
    Slide *slide = self.deck.slides[indexPath.row];
    
    NSLog(@"%@", slide);
    
 //compatability   playingCardCell.playingCardImageView.image = slide.cachedImage;
    return playingCardCell;
  }
  else {
    EditSlideCell *editSlideCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EditSlideCellIdentifier" forIndexPath:indexPath];
    
    Slide *slide = self.deck.slides[indexPath.row];
    
    
    
    editSlideCell.slide = slide;
    return editSlideCell;
    
  }
}

#pragma mark - LXReorderableCollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
  
  [self.deck moveFrom:fromIndexPath.item to:toIndexPath.item];
  
  [_collectionView reloadData];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
#if LX_LIMITED_MOVEMENT == 1
  PlayingCard *playingCard = [deck objectAtIndex:indexPath.item];
  
  switch (playingCard.suit) {
    case PlayingCardSuitSpade:
    case PlayingCardSuitClub:
      return YES;
    default:
      return NO;
  }
#else
  return YES;
#endif
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
#if LX_LIMITED_MOVEMENT == 1
  PlayingCard *fromPlayingCard = [deck objectAtIndex:fromIndexPath.item];
  PlayingCard *toPlayingCard = [deck objectAtIndex:toIndexPath.item];
  
  switch (toPlayingCard.suit) {
    case PlayingCardSuitSpade:
    case PlayingCardSuitClub:
      return fromPlayingCard.rank == toPlayingCard.rank;
    default:
      return NO;
  }
#else
  return YES;
#endif
}

- (IBAction)longPress:(id)sender {
  NEOColorPickerViewController *controller = [[NEOColorPickerViewController alloc] init];
  controller.delegate = self;
  controller.selectedColor = [UIColor redColor];
  controller.title = @"My dialog title";
  UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:controller];
  [self presentViewController:navVC animated:YES completion:nil];
}

- (void) colorPickerViewController:(NEOColorPickerBaseViewController *)controller didSelectColor:(UIColor *)color {
  // Do something with the color.
  _currentView.backgroundColor = color;
  [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void) colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller {
  [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
