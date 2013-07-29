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
  slide1.text = @"DeckPress";
  
  self.slides = [[NSArray alloc] initWithObjects:slide1, nil];
  
}

@end
