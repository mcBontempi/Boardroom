//
//  ImageMaker.m
//  DeckPress
//
//  Created by daren taylor on 07/08/2013.
//  Copyright (c) 2013 Daren taylor. All rights reserved.
//

#import "ImageMaker.h"
#import <QuartzCore/QuartzCore.h>

@implementation ImageMaker

+ (UIImage*)captureScreen:(UIView*)viewToCapture scale:(float)scale
{

  /*
  UIGraphicsBeginImageContextWithOptions(viewToCapture.frame.size, NO, scale);
  [viewToCapture drawViewHierarchyInRect:viewToCapture.bounds afterScreenUpdates:NO];
  UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  */
  
  
  UIGraphicsBeginImageContextWithOptions(viewToCapture.bounds.size,NO,scale);
  
  [viewToCapture.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  return snapshot;
}

+ (UIView *)createZoomedView:(CGFloat)zoom view:(UIView *)view
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
        [retView addSubview:[self createZoomedView:zoom view:subview]];
      }];
      
      return retView;
    }
  }
  return nil;
}

@end
