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

@implementation PresentationViewController{
  
  __weak IBOutlet UIScrollView *_scrollView;
  
  __weak IBOutlet UICollectionView *_collectionView;
  
  UIView *_currentView;
  
  NSTimer *_timer;
  AFHTTPClient *_client;
  
  NSInteger _changeCount;
  BOOL _uploading;
  
  NSInteger _pageNum;
  
  
  double _quality;
  
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)setCollectionView
{
  LXReorderableCollectionViewFlowLayout *layout = [[LXReorderableCollectionViewFlowLayout alloc] init];
  
  _col
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self setupCollectionView];
  
  
  _changeCount = 1;
  _uploading = NO;
  _pageNum = 0;
  
  _quality = 0.2;
  
  _scrollView.pagingEnabled = YES;
  _scrollView.delegate = self;
  
  //  NSLog(@"%d", _scrollView.subviews.count);
  [_scrollView addSubview:[[NSBundle mainBundle] loadNibNamed:@"yellowDouble" owner:self options:nil][0]];
  [_scrollView addSubview:[[NSBundle mainBundle] loadNibNamed:@"plainTitle" owner:self options:nil][0]];
  [_scrollView addSubview:[[NSBundle mainBundle] loadNibNamed:@"plainBody" owner:self options:nil][0]];
  [_scrollView addSubview:[[NSBundle mainBundle] loadNibNamed:@"plainBody" owner:self options:nil][0]];
  [_scrollView addSubview:[[NSBundle mainBundle] loadNibNamed:@"plainPic" owner:self options:nil][0]];
  
  
  
  // NSLog(@"%d", _scrollView.subviews.count);
  
  
  _currentView = [_scrollView subviews][0];
  
  _client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://162.13.5.127:8080"]];
  
  
  [self tryUpload];
}

- (void)tryUpload
{
  if (!_uploading && _changeCount) {
    
    
    _uploading = YES;
    _changeCount = 0;
    
    
    [self sendScreenshot];
    
    NSLog(@"a - send quality %f - page %d" , _quality, _pageNum);
  } else if(!_uploading && _quality <2.0 && !_changeCount) {
    _uploading = YES;
    if(_quality == 0.2) _quality = 1.0;
    else if(_quality == 1.0) _quality = 2.0;
    
    [self sendScreenshot];
    
    NSLog(@"b - send quality %f - page %d" , _quality, _pageNum);
  }
  
  
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  _scrollView.frame = CGRectMake(0,0,320,174);
  
  [_scrollView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
    CGRect rect = view.frame;
    rect.origin.x = idx*320;
    rect.size.width = 320;
    rect.size.height = 174;
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
    NSLog(@"%d", pageNum);
    _pageNum = pageNum;
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
  
  
  NSData *data = UIImagePNGRepresentation(image);
  
  // NSLog(@"image size %d", data.length);
  
  //  NSLog(@"end");
  
  //  NSLog(@"height = %f", image.size.height);
  
  NSMutableURLRequest *request = [_client multipartFormRequestWithMethod:@"POST" path:@"upload" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
    [formData appendPartWithFileData:data name:@"myFile" fileName:@"temp2.png" mimeType:@"image/png"];
  }];
  
  __weak id weakSelf = self;
  AFHTTPRequestOperation *operation = [_client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject){
    NSString *response = [operation responseString];
    //  NSLog(@"response: [%@]",response);
    NSLog(@"complete");
    
    _uploading = NO;
    
    [weakSelf tryUpload];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error){
    NSString *response = [operation responseString];
    //  NSLog(@"response: [%@]",response);
    
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
    }
    else if([view.class isSubclassOfClass:[UITextView class]]) {
      UITextView *srcTextView = (UITextView *)view;
      UITextView *retTextView =  [[UITextView alloc] initWithFrame:CGRectMake(view.frame.origin.x * zoom, view.frame.origin.y *zoom, view.frame.size.width*zoom, view.frame.size.height*zoom)];
      retTextView.text = srcTextView.text;
      retTextView.font = [UIFont fontWithName:srcTextView.font.fontName size:srcTextView.font.pointSize*zoom];
      return retTextView;
    }
    else if([view.class isSubclassOfClass:[UIView class]]) {
      UIView *retView =  [[UIView alloc] initWithFrame:CGRectMake(view.frame.origin.x * zoom, view.frame.origin.y *zoom, view.frame.size.width*zoom, view.frame.size.height*zoom)];
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
  UIView *duplicatedView = [self zoom:8 view:viewToCapture];
  
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


@end
