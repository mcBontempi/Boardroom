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
 // [self.delegate slideChanged:self.slide];
  _slide.text = _textView.text;
  [self.delegate viewChanged:self.contentView];
}

- (void)setSlide:(Slide *)slide
{
  _textView.text = slide.text;
}


@end
