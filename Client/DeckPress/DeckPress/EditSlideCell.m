//
//  EditSlideCell.m
//  DeckPress
//
//  Created by Daren taylor on 02/08/2013.
//  Copyright (c) 2013 Daren taylor. All rights reserved.
//

#import "EditSlideCell.h"

@interface EditSlideCell () <UITextViewDelegate>

@end

@implementation EditSlideCell
{
  __weak IBOutlet UITextView *_textView;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  if (self = [super initWithCoder:aDecoder]) {
    _textView.delegate = self;
  }
  return self;
}

- (void)textViewDidChange:(UITextView *)textView
{
  _slide.text = _textView.text;
  [self.delegate viewChanged:self.contentView];
}

- (void)setSlide:(Slide *)slide
{
  _slide = slide;
  _textView.text = slide.text;
  _textView.backgroundColor = slide.backgroundColor;
  _textView.textColor = slide.textColor;
}

@end
