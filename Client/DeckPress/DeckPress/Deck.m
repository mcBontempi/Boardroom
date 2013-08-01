//
//  Deck.m
//  DeckPress
//
//  Created by daren taylor on 29/07/2013.
//  Copyright (c) 2013 Daren taylor. All rights reserved.
//

#import "Deck.h"
#import "Slide.h"

@implementation Deck

- (void)makeTestData
{
  Slide *slide1 = [[Slide alloc] init];
  slide1.text = @"";
  
  Slide *slide2 = [[Slide alloc] init];
  slide2.text = @"DeckPress";
  
  Slide *slide3 = [[Slide alloc] init];
  slide3.text = @"DeckPress";
  
  Slide *slide4 = [[Slide alloc] init];
  slide4.text = @"DeckPress";
  
  Slide *slide5 = [[Slide alloc] init];
  slide5.text = @"DeckPress";

  self.slides = [[NSMutableArray alloc] initWithObjects:slide1, slide2, slide3, slide4, slide5, nil];
}

- (void)moveFrom:(NSUInteger)from to:(NSUInteger)to
{
  Slide *slide = [self.slides objectAtIndex:from];
  [self.slides removeObjectAtIndex:from];
  [self.slides insertObject:slide atIndex:to];
}
@end
