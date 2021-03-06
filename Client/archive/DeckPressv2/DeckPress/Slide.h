//
//  Slide.h
//  DeckPress
//
//  Created by daren taylor on 29/07/2013.
//  Copyright (c) 2013 Daren taylor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Slide : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIImage *image;

@end
