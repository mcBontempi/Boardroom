//
//  PresentationViewController.m
//  DeckPress
//
//  Created by Daren taylor on 20/06/2013.
//  Copyright (c) 2013 Daren taylor. All rights reserved.
//

#import "PresentationViewController.h"

@interface PresentationViewController ()

@end

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
  [_scrollView addSubview:[[NSBundle mainBundle] loadNibNamed:@"plainBody" owner:self options:nil][0]];
  [_scrollView addSubview:[[NSBundle mainBundle] loadNibNamed:@"plainPic" owner:self options:nil][0]];
  
  
  
  NSLog(@"%d", _scrollView.subviews.count);

  
  _currentView = [_scrollView subviews][0];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [_scrollView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
    CGRect rect = view.frame;
    rect.origin.x = idx*320;
    rect.size.width = 320;
    view.frame = rect;
  }];
  _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count*320, 174);
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}



- (void)scrollViewDidScroll:(UIScrollView *)sender {
  int pageNum = (int)(_scrollView.contentOffset.x / _scrollView.frame.size.width) +1;
  
  NSLog(@"%d", pageNum);

}











- (void)setupNewTimer
{
  _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerTick) userInfo:nil repeats:NO];
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
  UIImage *image = [self captureScreen:[self renderView]];
  
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
- (IBAction)send:(id)sender
{
  [self sendScreenshot];
}
-(UIImage*)captureScreen:(UIView*) viewToCapture{
  UIGraphicsBeginImageContextWithOptions(viewToCapture.bounds.size,NO, 2.0);
  //UIGraphicsBeginImageContext(viewToCapture.bounds.size);
  
  [viewToCapture.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return viewImage;
}




@end
