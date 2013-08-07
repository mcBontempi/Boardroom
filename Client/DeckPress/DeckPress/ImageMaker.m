//
//  ImageMaker.m
//  DeckPress
//
//  Created by daren taylor on 07/08/2013.
//  Copyright (c) 2013 Daren taylor. All rights reserved.
//

#import "ImageMaker.h"

@implementation ImageMaker

+(UIImage*)captureScreen:(UIView*) viewToCapture
{
  UIGraphicsBeginImageContextWithOptions(viewToCapture.bounds.size,NO,2.0);
  
  [viewToCapture.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  return viewImage;
}

@end
