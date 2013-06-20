//
//  ViewController.m
//  Boardroom
//
//  Created by daren taylor on 09/05/2013.
//  Copyright (c) 2013 daren taylor. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFHTTPClient.h>
#import <AFNetworking/AFHTTPRequestOperation.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *hiddenTextView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *renderView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation ViewController 
{
  NSTimer *_timer;
  AFHTTPClient *_client;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://www.tfl.gov.uk/assets/downloads/standard-tube-map.pdf"] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 100];
  [self.webView loadRequest: request];
  
  self.webView.delegate = self;
  
  _client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://162.13.5.127:8080"]];
  
  self.webView.scalesPageToFit=YES ;
    
    [self.textView becomeFirstResponder];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  [self setupNewTimer];
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

- (void)textViewDidChange:(UITextView *)textView
{
    self.hiddenTextView.text = self.textView.text;
}

@end
