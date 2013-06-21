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

@implementation PresentationViewController{
  
  __weak IBOutlet UIScrollView *_scrollView;
  
  UIView *_currentView;
  
  NSTimer *_timer;
  AFHTTPClient *_client;
  
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _scrollView.pagingEnabled = YES;
  _scrollView.delegate = self;
  
  NSLog(@"%d", _scrollView.subviews.count);
  
  [_scrollView addSubview:[[NSBundle mainBundle] loadNibNamed:@"plainTitle" owner:self options:nil][0]];
  [_scrollView addSubview:[[NSBundle mainBundle] loadNibNamed:@"plainBody" owner:self options:nil][0]];
  [_scrollView addSubview:[[NSBundle mainBundle] loadNibNamed:@"plainBody" owner:self options:nil][0]];
  [_scrollView addSubview:[[NSBundle mainBundle] loadNibNamed:@"plainPic" owner:self options:nil][0]];
  
  
  
  NSLog(@"%d", _scrollView.subviews.count);
  
  
  _currentView = [_scrollView subviews][0];
  
  _client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://162.13.5.127:8080"]];
  
  
  [self setupNewTimer];
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
  }];
  _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count*320, 174);
  
  
}


- (void)logSubviews:(UIView *)view
{
  [view.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
    
    NSLog(@">>");
    NSLog(@"%@: %@", NSStringFromClass(subview.class),  NSStringFromCGRect(subview.frame));
    
    [self logSubviews:subview];
    
    NSLog(@"<<");
  }];
}



- (void)scrollViewDidScroll:(UIScrollView *)sender {
  int pageNum = (int)(_scrollView.contentOffset.x / _scrollView.frame.size.width);
  
  NSLog(@"%d", pageNum);
  _currentView = _scrollView.subviews[pageNum];
  
}



- (void)setupNewTimer
{
  _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick) userInfo:nil repeats:NO];
}

- (void)timerTick
{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    [self sendScreenshot];
  });
}

- (void)sendScreenshot
{
  NSLog(@"start");
  UIImage *image = [self captureScreen:_currentView];
  
  
  NSLog(@"image size %d", UIImagePNGRepresentation(image).length);
  
  NSLog(@"end");
  
  NSLog(@"height = %f", image.size.height);
  
  NSMutableURLRequest *request = [_client multipartFormRequestWithMethod:@"POST" path:@"upload" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
    [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"myFile" fileName:@"temp2.png" mimeType:@"image/png"];
  }];
  
  __weak id weakSelf = self;
  AFHTTPRequestOperation *operation = [_client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject){
    NSString *response = [operation responseString];
    NSLog(@"response: [%@]",response);
    NSLog(@"complete");
    [weakSelf setupNewTimer];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error){
    NSString *response = [operation responseString];
    NSLog(@"response: [%@]",response);
    [weakSelf setupNewTimer];
  }];
  
  NSLog(@"send");
  
  [_client enqueueHTTPRequestOperation:operation];
  
}

- (UIView *)zoom:(CGFloat)zoom view:(UIView *)view
{
  UIView *retView = nil;
  
  if(view) {
    if(view.class == [UIView class]) {
      retView =  [[UIView alloc] initWithFrame:CGRectMake(view.frame.origin.x * zoom, view.frame.origin.y *zoom, view.frame.size.width*zoom, view.frame.size.height*zoom)];
    }
    else if(view.class == [UIImageView class]) {
      retView =  [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.origin.x * zoom, view.frame.origin.y *zoom, view.frame.size.width*zoom, view.frame.size.height*zoom)];
      
    //  [retView setImage: [view image]];
    }
    
    
    
    [view.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
      [view addSubview:[self zoom:zoom view:subview]];
    }];
  }
  return retView;
}



-(UIImage*)captureScreen:(UIView*) viewToCapture{
  
  
  UIView *duplicatedView =  viewToCapture;//[self zoom:2 view:viewToCapture];
  
  [self logSubviews:duplicatedView];
  
  UIGraphicsBeginImageContextWithOptions(duplicatedView.bounds.size,NO, 2.0);
  
  [duplicatedView layoutSubviews];
  
  [duplicatedView.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  return viewImage;
}




@end
