//
//  ImageMaker.h
//  DeckPress
//
//  Created by daren taylor on 07/08/2013.
//  Copyright (c) 2013 Daren taylor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageMaker : NSObject

+ (UIImage*)captureScreen:(UIView*) viewToCapture scale:(float)scale;
+ (UIView *)createZoomedView:(CGFloat)zoom view:(UIView *)view;

@end
