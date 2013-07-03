//
//  PlayingCardCell.m
//  LXRCVFL Example using Storyboard
//
//  Created by Stan Chang Khin Boon on 3/10/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "PlayingCardCell.h"
#import "PlayingCard.h"

@implementation PlayingCardCell
@synthesize playingCard;

- (void)setPlayingCard:(PlayingCard *)thePlayingCard
{
    playingCard = thePlayingCard;
 //   self.playingCardImageView.image = [UIImage imageNamed:playingCard.imageName];
  
  
  for (UIGestureRecognizer *recognizer in self.textView.gestureRecognizers) {
    if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]){
      recognizer.enabled = NO;
    }
  }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.playingCardImageView.alpha = highlighted ? 0.75f : 1.0f;
  

  self.backgroundColor = highlighted ? [UIColor blueColor] : [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected
{
  [super setSelected:selected];
  self.backgroundColor = selected ? [UIColor lightGrayColor] : [UIColor clearColor];

  self.playingCardImageView.image = selected ? [UIImage imageNamed:@"pageiconopen"] : [UIImage imageNamed:@"pageicon"];


}

@end
